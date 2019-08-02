var totalWaitPcs = 0
var totalTurn = 0
var totalCount = 0
var totaldone = 0
if (value) {
  var yesNoArr = ['Y', 'N']
  for (var i = 27; i <= 34; i++) {
    var target = this.root.findById('M' + i)
    var rand = yesNoArr[Math.floor(Math.random() * yesNoArr.length)];
    var waitingPCS = Math.floor(Math.random() * 117);
    totalWaitPcs += waitingPCS
    if (value[i - 27] > value[50 - i]) {
      currentCnt = value[50 - i] * 61
      totalCnt = value[i - 27] * 61
      occRate = (value[50 - i] / value[i - 27]) * 100
      totalCount += totalCnt
      totaldone += currentCnt
    } else {
      currentCnt = value[i - 27] * 61
      totalCnt = value[50 - i] * 61
      occRate = (value[i - 27] / value[50 - i]) * 100
      totalCount += totalCnt
      totaldone += currentCnt
    }
    var makeObj = {
      "enable": rand,
      "occRate": occRate,
      "waitingPcs": waitingPCS,
      "cycleRate": value[80 - i],
      "currentCnt": currentCnt,
      "totalCnt": totalCnt
    }
    target.data = makeObj;
    totalTurn += value[80 - i]
  }
  var workWaitTarget = this.root.findById('totalWaitingPcs')
  workWaitTarget.data = totalWaitPcs
  var cellTurnTarget = this.root.findById('totalCycleRate')
  cellTurnTarget.data = totalTurn / 8
  var totalTarget = this.root.findById('totalTotal')
  totalTarget.data = totalCount
  var totalCntTarget = this.root.findById('totalCount')
  totalCntTarget.data = totaldone
  var totalOccTarget = this.root.findById('totalOccRate')
  totalOccTarget.data = (totaldone / totalCount) * 100
}