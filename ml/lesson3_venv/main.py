import sys
import module_1

def print_hi(name):
    print(f'Hi, {name}')
    print(sys.argv)

if __name__ == "__main__":
    print_hi('Alex')

print(module_1.sum1(1,2))