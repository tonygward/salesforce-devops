@isTest
public class HelloWorldTest {
    @isTest
    static void testSayHello() {
        String result = HelloWorld.sayHello();
        System.assertEquals('Hello, World!', result, 'The sayHello method should return Hello, World!');
    }
}
