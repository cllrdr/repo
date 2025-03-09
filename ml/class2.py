class TestMethod:
    '''Базовый класс'''
    
    def __init__(self):
        print('TestMethod constructor call')
    
    def instance_method(self, p):
        '''Обычный метод объекта'''
        print('TestMethod instance_method call with param {}'.format(p))
        return p
    
    @classmethod
    def class_method(cls, p):
        '''
        Метод класса в качестве первого параметра 
        получает ссылку на класс. 
        Именно эта конструкция больше всего похожа
        на статические методы в других языках.
        '''
        print('{} class_method call with param {}'.format(cls.__name__, p))
        return p    
    
    @staticmethod
    def static_method(p):
        '''
        Статические методы в Python
        вообще не связаны с классом
        '''
        print('TestMethod static_method call with param {}'.format(p))
        return p
        
    
class TestMethodExt(TestMethod):   
    """Наследуемый класс"""
    
    def __init__(self):
        super().__init__()
        print('TestMethodExt constructor call')
        
    def instance_method(self, p):
        """Расширение метода базового класса позволяет избежать дублирования кода"""
        super().instance_method(p)
        print('TestMethodExt instance_method call with param {}'.format(p))
        return p
    
    def example_method(self, a, b, c=1, d='строка'):
        """Это строка документации"""
        return a+b
        
    def example_method_2(self, a, b, *, c=1, d='строка'):
        """Это строка документации"""
        return a+b 