function x = assign2struct(x, fieldName, value)

x.(fieldName) = value ;
x = makeSlaveRef(x) ;