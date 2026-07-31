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
    if(a.type == ValueType::INT && b.type == ValueType::INT)
        return makeInt(a.intValue + b.intValue);

    if(a.type == ValueType::STRING && b.type == ValueType::STRING)
        return makeString(a.stringValue + b.stringValue);

    if(a.type == ValueType::STRING && b.type == ValueType::INT)
        return makeString(a.stringValue + std::to_string(b.intValue));

    if(a.type == ValueType::INT && b.type == ValueType::STRING)
        return makeString(std::to_string(a.intValue) + b.stringValue);

    throw std::runtime_error("invalid operands for +");
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

Value operator==(const Value& a, const Value& b){
    return makeInt(a.intValue == b.intValue);
}

Value operator!=(const Value& a, const Value& b){
    return makeInt(a.intValue != b.intValue);
}

Value operator<(const Value& a, const Value& b){
    return makeInt(a.intValue < b.intValue);
}

Value operator>(const Value& a, const Value& b){
    return makeInt(a.intValue > b.intValue);
}

Value operator<=(const Value& a, const Value& b){
    return makeInt(a.intValue <= b.intValue);
}

Value operator>=(const Value& a, const Value& b){
    return makeInt(a.intValue >= b.intValue);
}