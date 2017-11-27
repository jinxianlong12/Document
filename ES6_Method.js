字符串:
1. codePoingAt(): 字符在字符串中的位置（从0开始).
var s = '𠮷a';
s.codePointAt(0) // 134071
s.codePointAt(1) // 57271
s.codePointAt(2) // 97

2. String.fromCodePoint():
String.fromCodePoint(0x20BB7)
// "𠮷"
String.fromCodePoint(0x78, 0x1f680, 0x79) === 'x\uD83D\uDE80y'
// true

3. at();
'abc'.at(0) // "a"
'𠮷'.at(0) // "𠮷"

4.  includes()：返回布尔值，表示是否找到了参数字符串。
    startsWith()：返回布尔值，表示参数字符串是否在源字符串的头部。
    endsWith()：返回布尔值，表示参数字符串是否在源字符串的尾部。

var s = 'Hello world!';
s.startsWith('Hello') // true
s.endsWith('!') // true
s.includes('o') // true

s.startsWith('world', 6) // true
s.endsWith('Hello', 5) // true
s.includes('Hello', 6) // false

5. repeat():repeat方法返回一个新字符串，表示将原字符串重复n次。
'x'.repeat(3) // "xxx"
'hello'.repeat(2) // "hellohello"
'na'.repeat(0) //

6. padStart()，padEnd():
'x'.padStart(4, 'ab') // 'abax'
'x'.padEnd(5, 'ab') // 'xabab'
'xxx'.padStart(2, 'ab') // 'xxx'
'abc'.padStart(10, '0123456789') //'0123456abc'
'09-12'.padStart(10, 'YYYY-MM-DD') // "YYYY-09-12"

7. 模板字符串:``

数字:
1. Number.isFinite():用来检查一个数值是否为有限的（finite）。
Number.isFinite(15); // true
Number.isFinite(0.8); // true
Number.isFinite(NaN); // false
Number.isFinite(Infinity); // false
Number.isFinite('foo'); // false

2. Number.isNaN() :用来检查一个值是否为数字.
Number.isNaN(NaN) // true
Number.isNaN(15) // false
Number.isNaN('15') // false
Number.isNaN(true) // false
Number.isNaN(9/NaN) // true
Number.isNaN('true'/0) // true
Number.isNaN('true'/'true') // true

3. Number.parseInt(), Number.parseFloat():
Number.parseInt('12.34') // 12
Number.parseFloat('123.45#') // 123.45

4. Number.isInteger():
Number.isInteger(25) // true
Number.isInteger(25.1) // false
Number.isInteger("15") // false
Number.isInteger(true) // false

5. Number.isSafeInteger(): 则是用来判断一个整数是否落在这个范围之内.
Number.isSafeInteger(3) // true
Number.isSafeInteger(1.2) // false
Number.isSafeInteger(9007199254740990) // true
Number.isSafeInteger(9007199254740992) // false

6. math.round()
Math.round(0.60) //1
Math.round(0.50) //1
Math.round(0.49) //0
Math.round(-4.40) //-4
Math.round(-4.60) //-5

7. Math.trunc(): 方法用于去除一个数的小数部分，返回整数部分。
Math.trunc(4.1) // 4
Math.trunc(4.9) // 4
Math.trunc(-4.1) // -4
Math.trunc(-4.9) // -4
Math.trunc('foo') // NaN
Math.trunc(); //NaN

8. Math.sign(): 方法用来判断一个数到底是正数、负数、还是零。
Math.sign(-5) // -1
Math.sign(5) // +1
Math.sign(0) // +0
Math.sign(-0) // -0
Math.sign(NaN) // NaN
Math.sign('foo'); // NaN
Math.sign();      // NaN

9. Math.cbrt() 方法用于计算一个数的立方根。
Math.cbrt('8') // 2
Math.cbrt('hello') // NaN

Math.hypot(): 方法返回所有参数的平方和的平方根。
Math.hypot(3, 4);        // 5
Math.hypot(3, 4, 5);     // 7.0710678118654755
Math.hypot(3, 4, '5');   // 7.0710678118654755
Math.hypot(-3);          // 3

10. 指数运算符（**):
2 ** 2 // 4
2 ** 3 // 8

11. Array.from(): 可以将各种值转为真正的数组，并且还提供map功能
let arrayLike = {
    '0': 'a',
    '1': 'b',
    '2': 'c',
    length: 3
};
let arr2 = Array.from(arrayLike); // ['a', 'b', 'c']

12. Array.of(): 方法用于将一组值，转换为数组。
Array.of(3, 11, 8) // [3,11,8]
Array.of(3) // [3]
Array.of(3).length // 1

Array() // []
Array(3) // [, , ,]
Array(3, 11, 8) // [3, 11, 8]

13. Array.prototype.copyWithin(target, start = 0, end = this.length):
target（必需）：从该位置开始替换数据。
start（可选）：从该位置开始读取数据，默认为0。如果为负值，表示倒数。
end（可选）：到该位置前停止读取数据，默认等于数组长度。如果为负值，表示倒数。
// 将3号位复制到0号位
[1, 2, 3, 4, 5].copyWithin(0, 3, 4)
// [4, 2, 3, 4, 5]

// -2相当于3号位，-1相当于4号位
[1, 2, 3, 4, 5].copyWithin(0, -2, -1)
// [4, 2, 3, 4, 5]

// 将3号位复制到0号位
[].copyWithin.call({length: 5, 3: 1}, 0, 3)
// {0: 1, 3: 1, length: 5}

// 将2号位到数组结束，复制到0号位
var i32a = new Int32Array([1, 2, 3, 4, 5]);
i32a.copyWithin(0, 2);
// Int32Array [3, 4, 5, 4, 5]

// 对于没有部署TypedArray的copyWithin方法的平台
// 需要采用下面的写法
[].copyWithin.call(new Int32Array([1, 2, 3, 4, 5]), 0, 3, 4);
// Int32Array [4, 2, 3, 4, 5]

13. find()和findIndex():
[1, 4, -5, 10].find((n) => n < 0)// -5
上面代码找出数组中第一个小于0的成员。

[1, 5, 10, 15].find(function(value, index, arr) {
  return value > 9;
}) // 10
上面代码中，find方法的回调函数可以接受三个参数，依次为当前的值、当前的位置和原数组。
数组实例的findIndex方法的用法与find方法非常类似，返回第一个符合条件的数组成员的位置，如果所有成员都不符合条件，则返回-1。
[1, 5, 10, 15].findIndex(function(value, index, arr) {
  return value > 9;
}) // 2

14. fill(): 方法使用给定值，填充一个数组。
['a', 'b', 'c'].fill(7) // [7, 7, 7]
new Array(3).fill(7) // [7, 7, 7]
['a', 'b', 'c'].fill(7, 1, 2) // ['a', 7, 'c']
上面代码表示，fill方法从1号位开始，向原数组填充7，到2号位之前结束。

15. entries()，keys()和values(): 用于遍历数组.
for (let index of ['a', 'b'].keys()) {
  console.log(index);
}
// 0
// 1

for (let elem of ['a', 'b'].values()) {
  console.log(elem);
}
// 'a'
// 'b'

for (let [index, elem] of ['a', 'b'].entries()) {
  console.log(index, elem);
}
// 0 "a"
// 1 "b"

16. Array.prototype.includes(): 方法返回一个布尔值, 表示某个数组是否包含给定的值，与字符串的includes方法类似。
[1, 2, 3].includes(2);     // true
[1, 2, 3].includes(4);     // false
[1, 2, NaN].includes(NaN); // true
[1, 2, 3].includes(3, 3);  // false
[1, 2, 3].includes(3, -1); // true

17. 数组空位:
// forEach方法
[,'a'].forEach((x,i) => console.log(i)); // 1

// filter方法
['a',,'b'].filter(x => true); // ['a','b']

// every方法
[,'a'].every(x => x==='a'); // true

// some方法
[,'a'].some(x => x !== 'a'); // false

// map方法
[,'a'].map(x => 1); // [,1]

// join方法
[,'a',undefined,null].join('#'); // "#a##"

// toString方法
[,'a',undefined,null].toString(); // ",a,,"

18. 函数
指定了默认值以后，函数的length属性，将返回没有指定默认值的参数个数。也就是说，指定了默认值后，length属性将失真。
(function (a) {}).length // 1
(function (a = 5) {}).length // 0
(function (a, b, c = 5) {}).length // 2
(function (a = 0, b, c) {}).length // 0
(function (a, b = 1, c) {}).length // 1
函数的length属性，不包括 rest 参数。
const sortNumbers = (...numbers) => numbers.sort();

扩展运算符（spread）是三个点（...）。它好比 rest 参数的逆运算，将一个数组转为用逗号分隔的参数序列。
console.log(1, ...[2, 3, 4], 5)
// 1 2 3 4 5
[...document.querySelectorAll('div')]
// [<div>, <div>, <div>]
该运算符主要用于函数调用。
// ES5的写法
Math.max.apply(null, [14, 3, 77])
// ES6的写法
Math.max(...[14, 3, 77])
// 等同于
Math.max(14, 3, 77);
[...'hello']
// [ "h", "e", "l", "l", "o" ]
只要具有Iterator接口的对象，都可以使用扩展运算符

function foo() {}
foo.name //"foo"

箭头函数:
var sum = (num1, num2) => num1 + num2;
// 等同于
var sum = function(num1, num2) {
  return num1 + num2;
};

arguments: 无需明确指出参数名,能访问参数时使用.
函数绑定运算符是并排的两个双冒号（::），双冒号左边是一个对象，右边是一个函数。

Object.is就是部署这个算法的新方法。它用来比较两个值是否严格相等，与严格比较运算符（===）的行为基本一致。
