Console Application
===

https://www.educative.io/answers/how-do-you-dockerize-a-maven-project
https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html

``` bash
make mvn ARG="archetype:generate \
    -DgroupId=it.matteogalacci.app \
    -DartifactId=demo-java-console-application \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 \
    -DinteractiveMode=false"
```