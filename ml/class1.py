class MyClass:
    """doc string here"""
    i = 12345

    def __init__(self, param):
        self.local_i = param
        self.__j = 444

    def f(self):
        """
        f doc
        """
        return 'hi world'
''' 
obj = MyClass()
print(obj.__doc__)
print(obj.f.__doc__)
print(obj.f)
print(obj.f())
'''


obj1 = MyClass(111)
obj2 = MyClass(222)

#print(obj1.i)
#obj1.i = 10
#print(obj1.i)

#MyClass.i = 30
#print(obj1.local_i)
#print(obj2.local_i)

print(MyClass.__dict__)



