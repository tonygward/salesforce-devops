@isTest
public class HelloWorldTest {
    @isTest
    static void testSayHello() {
        String result = HelloWorld.sayHello();
        System.Assert.areEqual('Hello, World!', result, 'The sayHello method should return Hello, World!');
    }
}
