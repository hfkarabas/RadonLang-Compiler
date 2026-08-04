#pragma once

#include <string>

enum class ValueType{
    INT,
    STRING
};

struct Value{
    ValueType type;
    int intValue = 0;
    std::string stringValue;
};

Value makeInt(int value);
Value makeString(const std::string& value);

void printValue(const Value& value);

Value operator+(const Value& a, const Value& b);
Value operator-(const Value& a, const Value& b);
Value operator*(const Value& a, const Value& b);
Value operator/(const Value& a, const Value& b);
Value operator==(const Value& a, const Value& b);
Value operator!=(const Value& a, const Value& b);
Value operator<(const Value& a, const Value& b);
Value operator>(const Value& a, const Value& b);
Value operator<=(const Value& a, const Value& b);
Value operator>=(const Value& a, const Value& b);

enum class BinaryType{
    INT_INT,
    INT_STRING,
    STRING_INT,
    STRING_STRING,
    INVALID
};