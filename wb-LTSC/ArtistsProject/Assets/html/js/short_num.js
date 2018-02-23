// 如果一个数字过长，通过在结尾加k,m的方式缩短
function shortNum(origin) {
  var originNum = parseInt(origin);
  var divideMillion = originNum / 1000000;
  console.log(divideMillion);
  if (divideMillion > 1) {
    var splited = ("" + divideMillion).split(".", 2);
    var result = splited[0];
    console.log(result);
    // 小数点后只保留一位
    if (splited[1] && splited[1].length > 0) {
      result += "." + splited[1][0] + "M";
    }
    console.log(result);
    return result;
  }
  var divideThousand = originNum / 1000;
  if (divideThousand > 1) {
    var splited = ("" + divideThousand).split(".", 2);
    var result = splited[0];
    console.log(result);
    // 小数点后只保留一位
    if (splited[1] && splited[1].length > 0) {
      result += "." + splited[1][0] + "K";
    }
    console.log(result);
    return result;
  }
  return originNum;
}

// console.log(shortNum("510"));