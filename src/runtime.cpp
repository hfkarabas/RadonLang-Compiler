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

BinaryType getBinaryType(ValueType a, ValueType b){
    if (a == ValueType::INT && b == ValueType::INT)
        return BinaryType::INT_INT;
    if (a == ValueType::INT && b == ValueType::STRING)
        return BinaryType::INT_STRING;
    if (a == ValueType::STRING && b == ValueType::INT)
        return BinaryType::STRING_INT;
    if (a == ValueType::STRING && b == ValueType::STRING)
        return BinaryType::STRING_STRING;

        return BinaryType::INVALID;
}

Value operator+(const Value& a, const Value& b){

    switch (getBinaryType(a.type, b.type)){
        case BinaryType::INT_INT:
            return makeInt(a.intValue + b.intValue);
        case BinaryType::STRING_STRING:
            return makeString(a.stringValue + b.stringValue);
        case BinaryType::INT_STRING:
            return makeString(std::to_string(a.intValue) + b.stringValue);
        case BinaryType::STRING_INT:
            return makeString(a.stringValue + std::to_string(b.intValue));

        default:
            throw std::runtime_error("Invalid operands for +");
    }
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