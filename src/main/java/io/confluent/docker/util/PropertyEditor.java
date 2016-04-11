package io.confluent.docker.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import joptsimple.OptionParser;
import joptsimple.OptionSet;
import joptsimple.ValueConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PropertyEditor {
  static final Logger log = LoggerFactory.getLogger(PropertyEditor.class);

  File targetFile;
  List<Pattern> includePatterns=new ArrayList<>();
  List<Pattern> excludePatterns=new ArrayList<>();
  boolean preserveCase=false;

  public File getTargetFile() {
    return targetFile;
  }

  public void setTargetFile(File targetFile) {
    this.targetFile = targetFile;
  }

  public List<Pattern> getIncludePatterns() {
    return includePatterns;
  }

  public void setIncludePatterns(List<Pattern> includePatterns) {
    this.includePatterns = includePatterns;
  }

  public List<Pattern> getExcludePatterns() {
    return excludePatterns;
  }

  public void setExcludePatterns(List<Pattern> excludePatterns) {
    this.excludePatterns = excludePatterns;
  }

  public void setPreserveCase(boolean preserveCase) {
    this.preserveCase = preserveCase;
  }

  public boolean getPreserveCase() {
    return preserveCase;
  }

  Map<String, String> findOverriddenValues(Map<String, String> environmentVariables) {
    Map<String, String> results = new LinkedHashMap<>();

    for(Map.Entry<String, String> env:environmentVariables.entrySet()){
      Matcher matcher=null;

      for(Pattern pattern:this.includePatterns){
        Matcher testMatch = pattern.matcher(env.getKey());

        if(testMatch.find()){
          matcher=testMatch;
          break;
        }
      }

      if(null==matcher){
        if(log.isDebugEnabled()){
          log.debug("{} did not match pattern. Skipping...", env.getKey());
        }
        continue;
      }

      boolean excludedKey = false;

      for(Pattern pattern:this.excludePatterns){
        Matcher testMatch = pattern.matcher(env.getKey());

        if(testMatch.find()){
          excludedKey=true;
          break;
        }
      }

      if(excludedKey){
        if(log.isDebugEnabled()){
          log.debug("Skipping {} because it matches an exclude regex.", env.getKey());
        }
        continue;
      }

      if(matcher.groupCount()!=1){
        throw new IllegalStateException("Include pattern must return capture group 1. Pattern: " + matcher.pattern().pattern());
      }

      String propertyName=matcher.group(1);
      propertyName=propertyName.replace('_', '.');
      if(!preserveCase){
        propertyName=propertyName.toLowerCase();
      }

      if(log.isInfoEnabled()){
        log.info("Overriding value for {} with value from environment variable {}", propertyName, env.getKey());
      }

      results.put(propertyName, env.getValue());
    }

    return results;
  }


  public void run() throws IOException {

    if(log.isInfoEnabled()) {
      log.info("Reading properties from {}", this.targetFile);
    }

    Properties properties = new Properties();

    try(FileInputStream inputStream = new FileInputStream(this.targetFile)) {
      properties.load(inputStream);
    }

    Map<String, String> environmentVariables = System.getenv();
    Map<String, String> overriddenValues = findOverriddenValues(environmentVariables);

    if(overriddenValues.isEmpty()) {
      if (log.isInfoEnabled()) {
        log.info("Found no overridden values.");
      }
      return;
    }

    properties.putAll(overriddenValues);

    if(log.isInfoEnabled()){
      log.info("Writing properties to {}", this.targetFile);
    }

    try(FileOutputStream outputStream = new FileOutputStream(this.targetFile)){
      properties.store(outputStream,
          String.format("Properties written by %s prior to docker boot.", this.getClass().getSimpleName())
          );
    }
  }

  static List<Pattern> createPatterns(OptionSet options, String option) {
    List<Pattern> results = new ArrayList<>();
    List<String> patterns = (List<String>) options.valuesOf(option);

    for(String s:patterns){
      try {
        results.add(Pattern.compile(s));
      } catch(Exception ex){
        if(log.isErrorEnabled()){
          log.error("Exception thrown while compiling regex '{}'", s, ex);
        }
        throw ex;
      }
    }

    return results;
  }


  static PropertyEditor createByArguments(String... args) throws Exception{
    OptionParser parser = new OptionParser();
    parser.accepts("file", "Absolute path to the properties file to edit.").withRequiredArg().ofType(File.class);
    parser.accepts("include", "Regular expression for environment variables to include. Must contain a capture group of 1 for the property name.").withRequiredArg();
    parser.accepts("exclude", "Regular expression for environment variables to exclude. Excludes execute after includes.").withRequiredArg();
    parser.accepts("preserve-case", "Flag to determine if the case of the environment variable should be preserved.");

    OptionSet options = parser.parse(args);

    PropertyEditor editor = new PropertyEditor();

    if(!options.hasArgument("file")){
      throw new IllegalStateException("file must be specified.");
    }

    if(!options.has("include")){
      throw new IllegalStateException("At least one include regex must be specifed.");
    }

    File targetFile = (File)options.valueOf("file");
    editor.setTargetFile(targetFile);
    List<Pattern> includes = createPatterns(options, "include");
    List<Pattern> excludes = createPatterns(options, "exclude");
    editor.setIncludePatterns(includes);
    editor.setExcludePatterns(excludes);

    if(options.has("preserve-case")) {
      editor.setPreserveCase(true);
    }

    return editor;
  }


  public static void main(String... args) throws Exception {
    PropertyEditor editor = createByArguments(args);
    editor.run();
  }

}
