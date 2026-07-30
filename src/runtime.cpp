#include <iostream>
#include "runtime.h"


Value makeInt(int value){
    Value v;
    v.type = ValueType::INT;
    v.intValue = value;
    return v;
}

Value makeString(const std::string& value){
    Value v;
    v.type = ValueType::STRING;
    v.stringValue = value;
    return v;
}

void printValue(const Value& value){
    switch(value.type){
        case ValueType::INT:
            std::cout << value.intValue << std::endl;
            break;

        case ValueType::STRING:
            std::cout << value.stringValue << std::endl;
            break;
    }
}

Value operator+(const Value& a, const Value& b){
    return makeInt(a.intValue + b.intValue);
}

Value operator-(const Value& a, const Value& b){
    return makeInt(a.intValue - b.intValue);
}

Value operator*(const Value& a, const Value& b){
    return makeInt(a.intValue * b.intValue);
}

Value operator/(const Value& a, const Value& b){
    return makeInt(a.intValue / b.intValue);
}