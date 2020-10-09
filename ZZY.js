if (this._timeout)
  clearTimeout(this._timeout);

if (!value.length)
  return;

// Please Setting Value
const cellCount = 3;
const time = 2000;
const tableId = 'table';
const nullObj = {
  index: "",
  data: ""
};

const totalCount = Math.floor(((value.length - 1) / cellCount) + 1);
const remainder = value.length % cellCount;

pagingData(value, 0, totalCount, remainder, cellCount, time, nullObj, tableId, this);

function pagingData(list, index, totalCount, remainder, cellCount, time, nullObj, tableId, self) {
  var shift = index * cellCount;
  var data;

  if (index + 1 == totalCount) {
    data = list.slice(shift);
    for (let i = 0; i < cellCount - remainder; i++)
      data.push(nullObj);
    index = 0;
  } else {
    data = list.slice(shift, cellCount + shift);
    index++;
  }
  self.parent.findById(tableId).data = data
  self._timeout = setTimeout(function () { pagingData(list, index, totalCount, remainder, cellCount, time, nullObj, tableId, self) }, time);
}