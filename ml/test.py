word = "hello"
print(type(word))

a = 1
d = "Да" if a == 1 else "Нет"
print(d)

for s in "string":
    print(s, type(s))

for i, s in enumerate('string'):
    print(i, s)

try:
    k = 1/0
except ZeroDivisionError:
    k = 333
except ArithmeticError:
    k=334
else:
    k = 100
finally:
    print(k)

def func(a, b):
    res = a + b
    return res

print(func(3, 5))

func1 = lambda x,y: x + y
print(func1(1,2))


def f1(a, b, *args):
    print(a)
    print(b)
    print(type(args), *args)

f1(3, 2, 10, 7, 10)