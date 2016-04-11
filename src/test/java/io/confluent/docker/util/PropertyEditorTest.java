package io.confluent.docker.util;


import org.junit.Assert;
import org.junit.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Exchanger;
import java.util.regex.Pattern;
import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.*;

public class PropertyEditorTest {

  @Test
  public void findOverriddenValues(){
    PropertyEditor propertyEditor = new PropertyEditor();
    propertyEditor.getIncludePatterns().add(
        Pattern.compile("KAFKA_(.*)")
    );
    propertyEditor.getExcludePatterns().add(
        Pattern.compile("KAFKA_HEAP_OPTS|KAFKA_JVM_PERFORMANCE_OPTS|KAFKA_OPTS|KAFKA_LOG4J_OPTS|KAFKA_JMX_OPTS")
    );

    final Map<String, String> expected = Collections.singletonMap("broker.id", "0");

    final Map<String, String> input = new LinkedHashMap<>();
    input.put("KAFKA_BROKER_ID", "0");
    input.put("KAFKA_HEAP_OPTS", "-xmx2048m");
    input.put("LOG_DIR", "/var/log/kafka");
    input.put("CA_CERTIFICATES_JAVA_VERSION", "20140324");
    input.put("CONFLUENT_GROUP", "confluent");
    input.put("CONFLUENT_USER", "confluent");
    input.put("HOME", "/root");
    input.put("HOSTNAME", "ff7ef0c2191b");
    input.put("JAVA_DEBIAN_VERSION", "8u72-b15-1~bpo8+1");
    input.put("JAVA_HOME", "/usr/lib/jvm/java-8-openjdk-amd64/jre");
    input.put("JAVA_VERSION", "8u72");
    input.put("LANG", "C.UTF-8");
    input.put("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin");
    input.put("PWD", "/usr/bin");
    input.put("SHLVL", "1");

    final Map<String, String> actual = propertyEditor.findOverriddenValues(input);
    Assert.assertEquals(expected, actual);
  }

  @Test
  public void findOverriddenValues_SameCase(){
    PropertyEditor propertyEditor = new PropertyEditor();
    propertyEditor.getIncludePatterns().add(
        Pattern.compile("zk_(.*)")
    );
    propertyEditor.getExcludePatterns().add(
        Pattern.compile("zk_id")
    );
    propertyEditor.setPreserveCase(true);
    final Map<String, String> expected = new LinkedHashMap<>();
    expected.put("tickTime", "2000");
    expected.put("initLimit", "5");
    expected.put("syncLimit", "2");
    expected.put("clientPort", "2181");
    expected.put("maxClientCnxns", "0");


    final Map<String, String> input = new LinkedHashMap<>();
    input.put("zk_id", "1");
    input.put("zk_tickTime", "2000");
    input.put("zk_initLimit", "5");
    input.put("zk_syncLimit", "2");
    input.put("zk_clientPort", "2181");
    input.put("zk_maxClientCnxns", "0");
    input.put("KAFKA_BROKER_ID", "0");
    input.put("KAFKA_HEAP_OPTS", "-xmx2048m");
    input.put("LOG_DIR", "/var/log/kafka");
    input.put("CA_CERTIFICATES_JAVA_VERSION", "20140324");
    input.put("CONFLUENT_GROUP", "confluent");
    input.put("CONFLUENT_USER", "confluent");
    input.put("HOME", "/root");
    input.put("HOSTNAME", "ff7ef0c2191b");
    input.put("JAVA_DEBIAN_VERSION", "8u72-b15-1~bpo8+1");
    input.put("JAVA_HOME", "/usr/lib/jvm/java-8-openjdk-amd64/jre");
    input.put("JAVA_VERSION", "8u72");
    input.put("LANG", "C.UTF-8");
    input.put("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin");
    input.put("PWD", "/usr/bin");
    input.put("SHLVL", "1");

    final Map<String, String> actual = propertyEditor.findOverriddenValues(input);
    Assert.assertEquals(expected, actual);
  }
  
  @Test
  public void createByArguments() throws Exception {

    String[] args = new String[]{
        "--file",
        "/etc/kafka/server.properties",
        "--include",
        "KAFKA_(.*)",
        "--exclude",
        "KAFKA_HEAP_OPTS|KAFKA_JVM_PERFORMANCE_OPTS|KAFKA_OPTS|KAFKA_LOG4J_OPTS|KAFKA_JMX_OPTS",
        "--preserve-case"
    };

    PropertyEditor editor = PropertyEditor.createByArguments(args);
    Assert.assertNotNull(editor);

    List<Pattern> includes = new ArrayList<>();
    includes.add(Pattern.compile("KAFKA_(.*)"));
    List<Pattern> excludes = new ArrayList<>();
    excludes.add(Pattern.compile("KAFKA_HEAP_OPTS|KAFKA_JVM_PERFORMANCE_OPTS|KAFKA_OPTS|KAFKA_LOG4J_OPTS|KAFKA_JMX_OPTS"));

    final File expectedFile = new File("/etc/kafka/server.properties");
    Assert.assertEquals(expectedFile, editor.getTargetFile());
    Assert.assertEquals(true, editor.getPreserveCase());
  }
}
