---
name: python-dev
description: Python Development
---

# Python Development Skill

## Overview
This skill helps you write, debug, optimize, and maintain Python applications. It provides best practices for idiomatic Python code (Pythonic style), proper error handling, testing strategies, project structure, virtual environments, and effective use of Python's standard library and ecosystem.

## When to Use This Skill
Use this skill when you need to:
- Write new Python scripts, modules, or packages
- Debug Python applications or understand error messages
- Design APIs, web applications, or data processing pipelines
- Work with Python's standard library and third-party packages
- Optimize Python code for performance
- Write tests and implement CI/CD
- Structure Python projects following best practices
- Work with virtual environments and dependency management
- Implement async/await patterns for concurrent operations

## Python Philosophy - The Zen of Python
```python
import this
```

Key principles:
- **Beautiful is better than ugly** - Write aesthetically pleasing code
- **Explicit is better than implicit** - Be clear about what code does
- **Simple is better than complex** - Favor simplicity over cleverness
- **Readability counts** - Code is read more than written
- **There should be one-- and preferably only one --obvious way to do it** - Consistency matters
- **If the implementation is hard to explain, it's a bad idea** - Complexity is a warning sign

## Project Structure

### Standard Python Project Layout
```
myproject/
├── .venv/                     # Virtual environment (not committed)
├── src/                       # Source code (modern layout)
│   └── myproject/
│       ├── __init__.py
│       ├── __main__.py        # Entry point for python -m myproject
│       ├── core/
│       │   ├── __init__.py
│       │   └── models.py
│       ├── api/
│       │   ├── __init__.py
│       │   └── routes.py
│       └── utils/
│           ├── __init__.py
│           └── helpers.py
├── tests/                     # Test files
│   ├── __init__.py
│   ├── test_core.py
│   └── test_api.py
├── docs/                      # Documentation
│   └── conf.py
├── scripts/                   # Utility scripts
│   └── setup_db.py
├── requirements.txt           # Production dependencies
├── requirements-dev.txt       # Development dependencies
├── pyproject.toml            # Project metadata (PEP 518)
├── setup.py                  # Package setup (if distributing)
├── README.md
├── .gitignore
└── .env.example              # Environment variable template
```

### Alternative Flat Layout (for smaller projects)
```
myproject/
├── .venv/
├── myproject/                # Source code at root
│   ├── __init__.py
│   └── main.py
├── tests/
├── requirements.txt
└── README.md
```

### Environment Setup
```bash
# Create virtual environment
python -m venv .venv

# Activate (Linux/Mac)
source .venv/bin/activate

# Activate (Windows)
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Install in development mode
pip install -e .

# Freeze current dependencies
pip freeze > requirements.txt
```

## Pythonic Code Patterns

### 1. List Comprehensions
```python
# ✅ Good - list comprehension
squares = [x**2 for x in range(10)]

# With condition
even_squares = [x**2 for x in range(10) if x % 2 == 0]

# ❌ Bad - traditional loop (less Pythonic)
squares = []
for x in range(10):
    squares.append(x**2)

# Dict comprehension
word_lengths = {word: len(word) for word in ['hello', 'world']}

# Set comprehension
unique_lengths = {len(word) for word in ['hello', 'world', 'hi']}

# Generator expression (lazy evaluation)
squares_gen = (x**2 for x in range(1000000))  # Doesn't compute until needed
```

### 2. Unpacking and Multiple Assignment
```python
# ✅ Good - tuple unpacking
x, y = 10, 20
a, b, c = [1, 2, 3]

# Swap values
x, y = y, x

# Extended unpacking
first, *middle, last = [1, 2, 3, 4, 5]
print(first)   # 1
print(middle)  # [2, 3, 4]
print(last)    # 5

# Function arguments
def greet(name, age):
    print(f"{name} is {age} years old")

person = ("Alice", 30)
greet(*person)  # Unpacks tuple

user_data = {"name": "Bob", "age": 25}
greet(**user_data)  # Unpacks dict

# ❌ Bad - manual indexing
first = items[0]
last = items[-1]
middle = items[1:-1]
```

### 3. Context Managers (with statement)
```python
# ✅ Good - automatic resource cleanup
with open('file.txt', 'r') as f:
    content = f.read()
# File is automatically closed

# Multiple context managers
with open('input.txt', 'r') as infile, open('output.txt', 'w') as outfile:
    outfile.write(infile.read())

# Custom context manager
from contextlib import contextmanager

@contextmanager
def timer(name):
    start = time.time()
    yield
    end = time.time()
    print(f"{name} took {end - start:.2f} seconds")

with timer("Database query"):
    # Expensive operation
    time.sleep(1)

# Class-based context manager
class DatabaseConnection:
    def __enter__(self):
        self.conn = connect_to_db()
        return self.conn
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.close()
        return False  # Don't suppress exceptions

# ❌ Bad - manual cleanup
f = open('file.txt', 'r')
content = f.read()
f.close()  # Easy to forget!
```

### 4. Enumerate and Zip
```python
# ✅ Good - enumerate for index and value
names = ['Alice', 'Bob', 'Charlie']
for i, name in enumerate(names):
    print(f"{i}: {name}")

# Start index at 1
for i, name in enumerate(names, start=1):
    print(f"{i}. {name}")

# ✅ Good - zip for parallel iteration
names = ['Alice', 'Bob', 'Charlie']
ages = [30, 25, 35]
for name, age in zip(names, ages):
    print(f"{name} is {age} years old")

# zip_longest for unequal lengths
from itertools import zip_longest
for name, age in zip_longest(names, ages, fillvalue='Unknown'):
    print(f"{name}: {age}")

# ❌ Bad - manual indexing
for i in range(len(names)):
    print(f"{i}: {names[i]}")
```

### 5. Generators and Iterators
```python
# ✅ Good - generator function (memory efficient)
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

for num in fibonacci(10):
    print(num)

# Generator expression
squares = (x**2 for x in range(1000000))  # Lazy evaluation

# Iterator protocol
class CountDown:
    def __init__(self, start):
        self.current = start
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.current <= 0:
            raise StopIteration
        self.current -= 1
        return self.current + 1

for num in CountDown(5):
    print(num)  # 5, 4, 3, 2, 1

# ❌ Bad - building entire list in memory
def fibonacci_list(n):
    result = []
    a, b = 0, 1
    for _ in range(n):
        result.append(a)
        a, b = b, a + b
    return result  # Uses much more memory
```

### 6. Decorators
```python
# Function decorator
def timer(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.2f}s")
        return result
    return wrapper

@timer
def slow_function():
    time.sleep(1)

# Decorator with arguments
def repeat(times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def greet(name):
    print(f"Hello, {name}!")

# Built-in decorators
class MyClass:
    @staticmethod
    def static_method():
        print("No self needed")
    
    @classmethod
    def class_method(cls):
        print(f"Called on {cls}")
    
    @property
    def computed_value(self):
        return self._value * 2
    
    @computed_value.setter
    def computed_value(self, value):
        self._value = value / 2

# functools decorators
from functools import lru_cache, wraps

@lru_cache(maxsize=128)
def expensive_function(n):
    # Results are cached
    return sum(range(n))

def my_decorator(func):
    @wraps(func)  # Preserves function metadata
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper
```

### 7. Named Tuples and Data Classes
```python
# Named tuple (immutable)
from collections import namedtuple

Point = namedtuple('Point', ['x', 'y'])
p = Point(10, 20)
print(p.x, p.y)  # 10 20

# Data class (Python 3.7+)
from dataclasses import dataclass, field

@dataclass
class Person:
    name: str
    age: int
    email: str = "unknown@example.com"  # Default value
    friends: list = field(default_factory=list)  # Mutable default
    
    def greet(self):
        return f"Hi, I'm {self.name}"

person = Person(name="Alice", age=30)
print(person.greet())

# Frozen dataclass (immutable)
@dataclass(frozen=True)
class ImmutablePoint:
    x: float
    y: float

# With type hints and validation
@dataclass
class Product:
    name: str
    price: float
    quantity: int = 0
    
    def __post_init__(self):
        if self.price < 0:
            raise ValueError("Price cannot be negative")
```

### 8. String Formatting
```python
name = "Alice"
age = 30
price = 19.99

# ✅ Good - f-strings (Python 3.6+, preferred)
message = f"Hello, {name}! You are {age} years old."
formatted = f"Price: ${price:.2f}"
debug = f"{name=}, {age=}"  # name='Alice', age=30

# Multi-line f-strings
message = (
    f"Name: {name}\n"
    f"Age: {age}\n"
    f"Status: {'adult' if age >= 18 else 'minor'}"
)

# Format method (older, still useful)
message = "Hello, {}! You are {} years old.".format(name, age)
message = "Hello, {name}! You are {age} years old.".format(name=name, age=age)

# ❌ Bad - old string formatting
message = "Hello, %s! You are %d years old." % (name, age)

# ❌ Bad - concatenation
message = "Hello, " + name + "! You are " + str(age) + " years old."
```

## Error Handling

### 1. Exception Handling Best Practices
```python
# ✅ Good - specific exceptions
try:
    with open('file.txt', 'r') as f:
        content = f.read()
except FileNotFoundError:
    print("File not found")
except PermissionError:
    print("Permission denied")
except Exception as e:
    print(f"Unexpected error: {e}")
    raise  # Re-raise if you can't handle it

# Multiple exceptions
try:
    result = risky_operation()
except (ValueError, TypeError) as e:
    print(f"Invalid input: {e}")

# else clause (runs if no exception)
try:
    result = process_data()
except ValueError:
    print("Processing failed")
else:
    print("Processing succeeded")
    save_result(result)

# finally clause (always runs)
try:
    connection = connect_to_db()
    data = fetch_data(connection)
except DatabaseError:
    print("Database error")
finally:
    connection.close()  # Always cleanup

# ❌ Bad - bare except
try:
    do_something()
except:  # Catches everything, including KeyboardInterrupt!
    pass

# ❌ Bad - exception as flow control
try:
    value = my_dict[key]
except KeyError:
    value = default_value

# ✅ Better - use dict.get()
value = my_dict.get(key, default_value)
```

### 2. Custom Exceptions
```python
# ✅ Good - custom exception hierarchy
class ApplicationError(Exception):
    """Base class for application exceptions"""
    pass

class ValidationError(ApplicationError):
    """Raised when data validation fails"""
    def __init__(self, field, message):
        self.field = field
        self.message = message
        super().__init__(f"{field}: {message}")

class DatabaseError(ApplicationError):
    """Raised when database operations fail"""
    pass

# Using custom exceptions
def validate_user(user_data):
    if not user_data.get('email'):
        raise ValidationError('email', 'Email is required')
    if '@' not in user_data['email']:
        raise ValidationError('email', 'Invalid email format')

try:
    validate_user({'name': 'Alice'})
except ValidationError as e:
    print(f"Validation failed - {e.field}: {e.message}")
```

### 3. Context Manager for Error Handling
```python
from contextlib import suppress

# Suppress specific exceptions
with suppress(FileNotFoundError):
    os.remove('file.txt')  # No error if file doesn't exist

# Better than:
try:
    os.remove('file.txt')
except FileNotFoundError:
    pass
```

## Type Hints and Static Analysis

### 1. Type Hints
```python
from typing import List, Dict, Optional, Union, Tuple, Callable, Any

# Basic type hints
def greet(name: str, age: int) -> str:
    return f"Hello, {name}! You are {age} years old."

# Collections
def process_items(items: List[str]) -> Dict[str, int]:
    return {item: len(item) for item in items}

# Optional (can be None)
def find_user(user_id: int) -> Optional[Dict[str, Any]]:
    if user_id in database:
        return database[user_id]
    return None

# Union (multiple types)
def process_input(value: Union[int, str]) -> str:
    return str(value)

# Callable (function type)
def apply_operation(func: Callable[[int, int], int], a: int, b: int) -> int:
    return func(a, b)

# Generic types
from typing import TypeVar, Generic

T = TypeVar('T')

class Stack(Generic[T]):
    def __init__(self) -> None:
        self.items: List[T] = []
    
    def push(self, item: T) -> None:
        self.items.append(item)
    
    def pop(self) -> T:
        return self.items.pop()

# Type aliases
UserId = int
UserData = Dict[str, Union[str, int]]

def get_user(user_id: UserId) -> UserData:
    return {"name": "Alice", "age": 30}

# Protocol (structural subtyping, Python 3.8+)
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None: ...

def render(obj: Drawable) -> None:
    obj.draw()  # Any object with draw() method works
```

### 2. Static Type Checking
```bash
# Install mypy
pip install mypy

# Run type checker
mypy myfile.py
mypy mypackage/

# pyproject.toml configuration
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

## Object-Oriented Programming

### 1. Classes and Inheritance
```python
# Basic class
class Person:
    # Class variable
    species = "Homo sapiens"
    
    def __init__(self, name: str, age: int):
        # Instance variables
        self.name = name
        self.age = age
    
    def greet(self) -> str:
        return f"Hi, I'm {self.name}"
    
    def __str__(self) -> str:
        return f"Person({self.name}, {self.age})"
    
    def __repr__(self) -> str:
        return f"Person(name={self.name!r}, age={self.age!r})"

# Inheritance
class Employee(Person):
    def __init__(self, name: str, age: int, employee_id: str):
        super().__init__(name, age)
        self.employee_id = employee_id
    
    def greet(self) -> str:
        # Override parent method
        return f"Hi, I'm {self.name}, employee #{self.employee_id}"

# Multiple inheritance
class Flyer:
    def fly(self):
        print("Flying!")

class Swimmer:
    def swim(self):
        print("Swimming!")

class Duck(Flyer, Swimmer):
    pass

duck = Duck()
duck.fly()
duck.swim()
```

### 2. Properties and Descriptors
```python
# Property decorator
class Temperature:
    def __init__(self, celsius: float):
        self._celsius = celsius
    
    @property
    def celsius(self) -> float:
        return self._celsius
    
    @celsius.setter
    def celsius(self, value: float):
        if value < -273.15:
            raise ValueError("Temperature below absolute zero")
        self._celsius = value
    
    @property
    def fahrenheit(self) -> float:
        return self._celsius * 9/5 + 32
    
    @fahrenheit.setter
    def fahrenheit(self, value: float):
        self.celsius = (value - 32) * 5/9

temp = Temperature(25)
print(temp.fahrenheit)  # 77.0
temp.fahrenheit = 86
print(temp.celsius)  # 30.0

# Descriptor protocol (advanced)
class ValidatedString:
    def __init__(self, min_length: int = 0):
        self.min_length = min_length
    
    def __set_name__(self, owner, name):
        self.name = f"_{name}"
    
    def __get__(self, obj, objtype=None):
        return getattr(obj, self.name, "")
    
    def __set__(self, obj, value):
        if len(value) < self.min_length:
            raise ValueError(f"Must be at least {self.min_length} chars")
        setattr(obj, self.name, value)

class User:
    username = ValidatedString(min_length=3)
    email = ValidatedString(min_length=5)
```

### 3. Abstract Base Classes
```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass
    
    @abstractmethod
    def perimeter(self) -> float:
        pass
    
    def describe(self) -> str:
        # Concrete method
        return f"Area: {self.area()}, Perimeter: {self.perimeter()}"

class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height
    
    def area(self) -> float:
        return self.width * self.height
    
    def perimeter(self) -> float:
        return 2 * (self.width + self.height)

# Cannot instantiate ABC
# shape = Shape()  # TypeError

rect = Rectangle(5, 3)
print(rect.describe())
```

### 4. Magic Methods (Dunder Methods)
```python
class Vector:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y
    
    def __str__(self) -> str:
        return f"Vector({self.x}, {self.y})"
    
    def __repr__(self) -> str:
        return f"Vector(x={self.x}, y={self.y})"
    
    def __add__(self, other: 'Vector') -> 'Vector':
        return Vector(self.x + other.x, self.y + other.y)
    
    def __mul__(self, scalar: float) -> 'Vector':
        return Vector(self.x * scalar, self.y * scalar)
    
    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Vector):
            return NotImplemented
        return self.x == other.x and self.y == other.y
    
    def __len__(self) -> int:
        return 2
    
    def __getitem__(self, index: int) -> float:
        if index == 0:
            return self.x
        elif index == 1:
            return self.y
        raise IndexError("Vector index out of range")
    
    def __call__(self) -> float:
        # Makes instance callable
        return (self.x ** 2 + self.y ** 2) ** 0.5

v1 = Vector(1, 2)
v2 = Vector(3, 4)
v3 = v1 + v2  # Uses __add__
print(v3)  # Uses __str__
print(v1[0])  # Uses __getitem__
print(v1())  # Uses __call__, returns magnitude
```

## Functional Programming

### 1. Higher-Order Functions
```python
# map, filter, reduce
numbers = [1, 2, 3, 4, 5]

# map - transform each element
squares = list(map(lambda x: x**2, numbers))
# ✅ Better - list comprehension
squares = [x**2 for x in numbers]

# filter - select elements
evens = list(filter(lambda x: x % 2 == 0, numbers))
# ✅ Better - list comprehension
evens = [x for x in numbers if x % 2 == 0]

# reduce - accumulate
from functools import reduce
sum_all = reduce(lambda x, y: x + y, numbers)
# ✅ Better - built-in sum
sum_all = sum(numbers)

# Useful higher-order functions
sorted_items = sorted(items, key=lambda x: x.price)
max_item = max(items, key=lambda x: x.value)
```

### 2. Partial Functions
```python
from functools import partial

def power(base: float, exponent: float) -> float:
    return base ** exponent

# Create specialized functions
square = partial(power, exponent=2)
cube = partial(power, exponent=3)

print(square(5))  # 25
print(cube(5))    # 125
```

### 3. Function Composition
```python
from functools import reduce

def compose(*functions):
    """Compose functions right to left"""
    def inner(arg):
        return reduce(lambda x, f: f(x), reversed(functions), arg)
    return inner

def add_one(x):
    return x + 1

def double(x):
    return x * 2

def square(x):
    return x ** 2

# Compose: square(double(add_one(x)))
pipeline = compose(add_one, double, square)
print(pipeline(3))  # square(double(4)) = square(8) = 64
```

## Async/Await (Asynchronous Programming)

### 1. Basic Async/Await
```python
import asyncio

# Async function
async def fetch_data(url: str) -> str:
    print(f"Fetching {url}...")
    await asyncio.sleep(1)  # Simulate network delay
    return f"Data from {url}"

# Run async function
async def main():
    result = await fetch_data("https://api.example.com")
    print(result)

# Execute
asyncio.run(main())
```

### 2. Concurrent Async Operations
```python
async def fetch_all():
    # Run concurrently with gather
    results = await asyncio.gather(
        fetch_data("https://api1.com"),
        fetch_data("https://api2.com"),
        fetch_data("https://api3.com"),
    )
    return results

# Run with timeout
async def fetch_with_timeout():
    try:
        result = await asyncio.wait_for(
            fetch_data("https://slow-api.com"),
            timeout=2.0
        )
    except asyncio.TimeoutError:
        print("Request timed out")

# Create tasks for more control
async def process_tasks():
    task1 = asyncio.create_task(fetch_data("url1"))
    task2 = asyncio.create_task(fetch_data("url2"))
    
    result1 = await task1
    result2 = await task2
```

### 3. Async Context Managers
```python
class AsyncDatabaseConnection:
    async def __aenter__(self):
        print("Connecting to database...")
        await asyncio.sleep(0.1)
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        print("Closing database connection...")
        await asyncio.sleep(0.1)
    
    async def query(self, sql: str):
        await asyncio.sleep(0.1)
        return f"Results for: {sql}"

async def use_db():
    async with AsyncDatabaseConnection() as db:
        result = await db.query("SELECT * FROM users")
        print(result)
```

### 4. Async Generators
```python
async def async_range(count: int):
    for i in range(count):
        await asyncio.sleep(0.1)
        yield i

async def consume_async_gen():
    async for value in async_range(5):
        print(value)
```

## Testing

### 1. Unit Tests with unittest
```python
import unittest

def add(a: int, b: int) -> int:
    return a + b

class TestMath(unittest.TestCase):
    def setUp(self):
        """Run before each test"""
        self.test_data = [1, 2, 3]
    
    def tearDown(self):
        """Run after each test"""
        pass
    
    def test_add_positive(self):
        self.assertEqual(add(2, 3), 5)
    
    def test_add_negative(self):
        self.assertEqual(add(-2, -3), -5)
    
    def test_add_zero(self):
        self.assertEqual(add(0, 0), 0)
    
    def test_list_length(self):
        self.assertEqual(len(self.test_data), 3)
    
    def test_raises_exception(self):
        with self.assertRaises(TypeError):
            add("2", 3)
    
    @unittest.skip("Not implemented yet")
    def test_future_feature(self):
        pass

if __name__ == '__main__':
    unittest.main()
```

### 2. Pytest (Modern, Preferred)
```python
import pytest

# Simple test
def test_add():
    assert add(2, 3) == 5
    assert add(-2, -3) == -5

# Parametrized tests
@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (-2, -3, -5),
    (0, 0, 0),
    (1, -1, 0),
])
def test_add_parametrized(a, b, expected):
    assert add(a, b) == expected

# Fixtures
@pytest.fixture
def sample_user():
    return {"name": "Alice", "age": 30}

def test_user_name(sample_user):
    assert sample_user["name"] == "Alice"

# Exception testing
def test_raises():
    with pytest.raises(ValueError):
        raise ValueError("Invalid value")

# Mocking
from unittest.mock import Mock, patch

def test_with_mock():
    mock_db = Mock()
    mock_db.get_user.return_value = {"name": "Alice"}
    
    result = mock_db.get_user(1)
    assert result["name"] == "Alice"
    mock_db.get_user.assert_called_once_with(1)

# Patching
@patch('module.function')
def test_with_patch(mock_function):
    mock_function.return_value = 42
    result = module.function()
    assert result == 42

# Temporary files
def test_with_tmpdir(tmp_path):
    file = tmp_path / "test.txt"
    file.write_text("test content")
    assert file.read_text() == "test content"
```

### 3. Test Coverage
```bash
# Install coverage
pip install pytest-cov

# Run with coverage
pytest --cov=mypackage tests/

# Generate HTML report
pytest --cov=mypackage --cov-report=html tests/

# Coverage configuration in pyproject.toml
[tool.coverage.run]
source = ["mypackage"]
omit = ["*/tests/*", "*/migrations/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise NotImplementedError",
]
```

### 4. Mock and Patch
```python
from unittest.mock import Mock, MagicMock, patch, call

# Mock object
mock_db = Mock()
mock_db.get_user.return_value = {"id": 1, "name": "Alice"}
user = mock_db.get_user(1)

# Assert calls
mock_db.get_user.assert_called_once_with(1)
mock_db.get_user.assert_called()

# MagicMock (supports magic methods)
mock = MagicMock()
mock.__len__.return_value = 5
len(mock)  # 5

# Patching functions
with patch('module.expensive_function') as mock_func:
    mock_func.return_value = "mocked result"
    result = module.expensive_function()
    assert result == "mocked result"

# Patching methods
class MyClass:
    def method(self):
        return "real"

with patch.object(MyClass, 'method', return_value="mocked"):
    obj = MyClass()
    assert obj.method() == "mocked"

# Decorator patching
@patch('requests.get')
def test_api_call(mock_get):
    mock_get.return_value.json.return_value = {"data": "test"}
    result = fetch_data()
    assert result["data"] == "test"

# Side effects
mock = Mock(side_effect=[1, 2, 3])
print(mock())  # 1
print(mock())  # 2
print(mock())  # 3

# Exception side effect
mock = Mock(side_effect=ValueError("Error"))
# mock() raises ValueError
```

## Web Development

### 1. Flask (Micro Framework)
```python
from flask import Flask, request, jsonify

app = Flask(__name__)

# Simple route
@app.route('/')
def hello():
    return 'Hello, World!'

# Route with parameter
@app.route('/user/<username>')
def show_user(username):
    return f'User: {username}'

# POST endpoint
@app.route('/api/users', methods=['POST'])
def create_user():
    data = request.get_json()
    # Process data
    return jsonify({"id": 1, "name": data["name"]}), 201

# Query parameters
@app.route('/search')
def search():
    query = request.args.get('q', '')
    return f'Searching for: {query}'

# Error handling
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Not found"}), 404

if __name__ == '__main__':
    app.run(debug=True)
```

### 2. FastAPI (Modern, Type-Hinted)
```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List

app = FastAPI()

# Pydantic models for validation
class User(BaseModel):
    id: int
    name: str
    email: str
    age: int | None = None

class UserCreate(BaseModel):
    name: str
    email: str
    age: int | None = None

# In-memory database
users_db: List[User] = []

# GET endpoint
@app.get("/users", response_model=List[User])
async def get_users():
    return users_db

# GET with path parameter
@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: int):
    for user in users_db:
        if user.id == user_id:
            return user
    raise HTTPException(status_code=404, detail="User not found")

# POST endpoint
@app.post("/users", response_model=User, status_code=201)
async def create_user(user: UserCreate):
    new_user = User(
        id=len(users_db) + 1,
        name=user.name,
        email=user.email,
        age=user.age
    )
    users_db.append(new_user)
    return new_user

# Query parameters with validation
@app.get("/search")
async def search(q: str, limit: int = 10, skip: int = 0):
    return {
        "query": q,
        "limit": limit,
        "skip": skip
    }

# Dependency injection
def get_current_user():
    # Authentication logic
    return {"id": 1, "name": "Alice"}

@app.get("/me")
async def read_users_me(current_user: dict = Depends(get_current_user)):
    return current_user

# Run with: uvicorn main:app --reload
```

### 3. Django (Full Framework)
```python
# models.py
from django.db import models

class User(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.name
    
    class Meta:
        ordering = ['-created_at']

# views.py
from django.http import JsonResponse
from django.views import View
from .models import User

class UserListView(View):
    def get(self, request):
        users = User.objects.all().values()
        return JsonResponse(list(users), safe=False)
    
    def post(self, request):
        data = json.loads(request.body)
        user = User.objects.create(**data)
        return JsonResponse({"id": user.id}, status=201)

# urls.py
from django.urls import path
from .views import UserListView

urlpatterns = [
    path('api/users/', UserListView.as_view()),
]
```

## Database Operations

### 1. SQLite (Built-in)
```python
import sqlite3

# Connect to database
conn = sqlite3.connect('database.db')
cursor = conn.cursor()

# Create table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL
    )
''')

# Insert data
cursor.execute(
    "INSERT INTO users (name, email) VALUES (?, ?)",
    ("Alice", "alice@example.com")
)
conn.commit()

# Query data
cursor.execute("SELECT * FROM users WHERE name = ?", ("Alice",))
rows = cursor.fetchall()
for row in rows:
    print(row)

# Using context manager
with sqlite3.connect('database.db') as conn:
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    # Connection automatically committed/rolled back

conn.close()
```

### 2. SQLAlchemy (ORM)
```python
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

# Define model
class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    
    def __repr__(self):
        return f"<User(name={self.name}, email={self.email})>"

# Create engine and session
engine = create_engine('sqlite:///database.db')
Base.metadata.create_all(engine)
Session = sessionmaker(bind=engine)
session = Session()

# Create
user = User(name="Alice", email="alice@example.com")
session.add(user)
session.commit()

# Read
users = session.query(User).filter_by(name="Alice").all()
user = session.query(User).filter(User.id == 1).first()

# Update
user = session.query(User).filter_by(id=1).first()
user.email = "newemail@example.com"
session.commit()

# Delete
session.delete(user)
session.commit()

# Close session
session.close()
```

### 3. PostgreSQL with psycopg2
```python
import psycopg2
from psycopg2.extras import RealDictCursor

# Connect
conn = psycopg2.connect(
    host="localhost",
    database="mydb",
    user="user",
    password="password"
)

# Use dict cursor for named columns
cursor = conn.cursor(cursor_factory=RealDictCursor)

# Execute query
cursor.execute("SELECT * FROM users WHERE id = %s", (1,))
user = cursor.fetchone()
print(user['name'])

# Insert with returning
cursor.execute(
    "INSERT INTO users (name, email) VALUES (%s, %s) RETURNING id",
    ("Bob", "bob@example.com")
)
user_id = cursor.fetchone()['id']
conn.commit()

cursor.close()
conn.close()
```

## File I/O and Data Formats

### 1. File Operations
```python
# Reading files
with open('file.txt', 'r') as f:
    content = f.read()  # Read entire file

with open('file.txt', 'r') as f:
    lines = f.readlines()  # List of lines

with open('file.txt', 'r') as f:
    for line in f:  # Memory efficient iteration
        process(line.strip())

# Writing files
with open('output.txt', 'w') as f:
    f.write("Hello, World!\n")
    f.writelines(['Line 1\n', 'Line 2\n'])

# Appending
with open('log.txt', 'a') as f:
    f.write("New log entry\n")

# Binary files
with open('image.png', 'rb') as f:
    data = f.read()

with open('output.png', 'wb') as f:
    f.write(data)

# Path operations
from pathlib import Path

path = Path('data/files/document.txt')
print(path.name)       # document.txt
print(path.stem)       # document
print(path.suffix)     # .txt
print(path.parent)     # data/files
print(path.exists())   # True/False

# Create directories
path.parent.mkdir(parents=True, exist_ok=True)

# List files
for file in Path('data').glob('*.txt'):
    print(file)
```

### 2. JSON
```python
import json

# Serialize (dump)
data = {"name": "Alice", "age": 30, "hobbies": ["reading", "coding"]}

# To string
json_string = json.dumps(data, indent=2)

# To file
with open('data.json', 'w') as f:
    json.dump(data, f, indent=2)

# Deserialize (load)
json_string = '{"name": "Bob", "age": 25}'
data = json.loads(json_string)

with open('data.json', 'r') as f:
    data = json.load(f)

# Custom encoder
class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age

class UserEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, User):
            return {"name": obj.name, "age": obj.age}
        return super().default(obj)

user = User("Alice", 30)
json.dumps(user, cls=UserEncoder)
```

### 3. CSV
```python
import csv

# Reading CSV
with open('data.csv', 'r') as f:
    reader = csv.reader(f)
    header = next(reader)  # Skip header
    for row in reader:
        print(row)

# Reading with DictReader
with open('data.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row['name'], row['age'])

# Writing CSV
with open('output.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['name', 'age'])
    writer.writerow(['Alice', 30])
    writer.writerows([
        ['Bob', 25],
        ['Charlie', 35]
    ])

# Writing with DictWriter
with open('output.csv', 'w', newline='') as f:
    fieldnames = ['name', 'age']
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerow({'name': 'Alice', 'age': 30})
```

### 4. YAML
```python
import yaml

# Reading YAML
with open('config.yaml', 'r') as f:
    config = yaml.safe_load(f)

# Writing YAML
data = {
    'database': {
        'host': 'localhost',
        'port': 5432
    },
    'features': ['auth', 'api', 'admin']
}

with open('config.yaml', 'w') as f:
    yaml.dump(data, f, default_flow_style=False)
```

## Performance Optimization

### 1. Profiling
```python
# Time measurement
import time

start = time.time()
expensive_operation()
end = time.time()
print(f"Took {end - start:.2f} seconds")

# cProfile
import cProfile
import pstats

cProfile.run('my_function()', 'profile_stats')

# View stats
with open('profile_output.txt', 'w') as f:
    p = pstats.Stats('profile_stats', stream=f)
    p.sort_stats('cumulative')
    p.print_stats()

# Line profiler
# pip install line_profiler
# kernprof -l -v script.py

@profile  # Added by line_profiler
def slow_function():
    total = 0
    for i in range(1000000):
        total += i
    return total
```

### 2. Memory Optimization
```python
# Generators vs Lists
# ❌ Bad - loads everything in memory
def get_numbers():
    return [i for i in range(1000000)]

# ✅ Good - lazy evaluation
def get_numbers():
    for i in range(1000000):
        yield i

# __slots__ for classes
class Point:
    __slots__ = ['x', 'y']  # Saves memory
    
    def __init__(self, x, y):
        self.x = x
        self.y = y

# Without __slots__, each instance has __dict__
```

### 3. Caching
```python
from functools import lru_cache, cache

# LRU Cache
@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

# Unlimited cache (Python 3.9+)
@cache
def expensive_computation(x):
    # Computation here
    return result

# Manual caching
cache_dict = {}

def cached_function(arg):
    if arg not in cache_dict:
        cache_dict[arg] = expensive_operation(arg)
    return cache_dict[arg]
```

### 4. List vs Deque
```python
from collections import deque

# ✅ Good for queue operations (O(1) append/pop from both ends)
queue = deque()
queue.append(1)
queue.appendleft(0)
queue.pop()
queue.popleft()

# ❌ Bad - list is O(n) for pop(0) and insert(0, x)
queue = []
queue.append(1)
queue.insert(0, 0)  # Slow!
queue.pop(0)        # Slow!
```

## Common Patterns and Idioms

### 1. EAFP vs LBYL
```python
# EAFP (Easier to Ask Forgiveness than Permission) - Pythonic
try:
    value = my_dict[key]
except KeyError:
    value = default_value

try:
    result = risky_operation()
except SomeException:
    handle_error()

# LBYL (Look Before You Leap) - Not Pythonic
if key in my_dict:
    value = my_dict[key]
else:
    value = default_value

# Better: use dict methods
value = my_dict.get(key, default_value)
```

### 2. Chaining Comparisons
```python
# ✅ Good - Pythonic chaining
if 0 < x < 10:
    print("x is between 0 and 10")

# ❌ Bad
if x > 0 and x < 10:
    print("x is between 0 and 10")
```

### 3. Ternary Operator
```python
# ✅ Good - ternary expression
result = "even" if x % 2 == 0 else "odd"

# ❌ Bad
if x % 2 == 0:
    result = "even"
else:
    result = "odd"
```

### 4. Any and All
```python
numbers = [2, 4, 6, 8]

# Check if all elements satisfy condition
all_even = all(x % 2 == 0 for x in numbers)

# Check if any element satisfies condition
has_even = any(x % 2 == 0 for x in numbers)

# Empty iterables
all([])  # True
any([])  # False
```

### 5. Default Dict
```python
from collections import defaultdict

# Regular dict
word_count = {}
for word in words:
    if word not in word_count:
        word_count[word] = 0
    word_count[word] += 1

# ✅ Better - defaultdict
word_count = defaultdict(int)
for word in words:
    word_count[word] += 1

# With list
groups = defaultdict(list)
for item in items:
    groups[item.category].append(item)
```

### 6. Counter
```python
from collections import Counter

# Count occurrences
words = ['apple', 'banana', 'apple', 'cherry', 'banana', 'apple']
counter = Counter(words)
print(counter)  # Counter({'apple': 3, 'banana': 2, 'cherry': 1})

# Most common
counter.most_common(2)  # [('apple', 3), ('banana', 2)]

# Operations
c1 = Counter(['a', 'b', 'c'])
c2 = Counter(['b', 'c', 'd'])
c1 + c2  # Combine counts
c1 - c2  # Subtract counts
```

## Logging
```python
import logging

# Basic configuration
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# Log levels
logger.debug("Debug information")
logger.info("Informational message")
logger.warning("Warning message")
logger.error("Error message")
logger.critical("Critical message")

# With exception info
try:
    risky_operation()
except Exception:
    logger.exception("Operation failed")  # Includes traceback

# Advanced configuration
import logging.config

LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s'
        },
    },
    'handlers': {
        'file': {
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': 'app.log',
            'maxBytes': 10485760,  # 10MB
            'backupCount': 5,
            'formatter': 'standard',
        },
    },
    'loggers': {
        '': {
            'handlers': ['file'],
            'level': 'INFO',
        },
    }
}

logging.config.dictConfig(LOGGING_CONFIG)
```

## Environment Variables and Configuration
```python
import os
from pathlib import Path
from dotenv import load_dotenv

# Load from .env file
load_dotenv()

# Get environment variables
DATABASE_URL = os.getenv('DATABASE_URL', 'sqlite:///default.db')
SECRET_KEY = os.environ['SECRET_KEY']  # Raises error if not found
DEBUG = os.getenv('DEBUG', 'False') == 'True'

# Using dataclass for config
from dataclasses import dataclass

@dataclass
class Config:
    database_url: str
    secret_key: str
    debug: bool = False
    
    @classmethod
    def from_env(cls):
        return cls(
            database_url=os.getenv('DATABASE_URL', 'sqlite:///db.sqlite'),
            secret_key=os.environ['SECRET_KEY'],
            debug=os.getenv('DEBUG', 'False') == 'True'
        )

config = Config.from_env()
```

## File Creation Workflow

When creating Python files:

1. **Create in `/home/claude` first** for development
2. **Use proper package structure**:
```
   /home/claude/myproject/
   ├── .venv/
   ├── src/
   │   └── myproject/
   │       ├── __init__.py
   │       └── main.py
   ├── tests/
   ├── requirements.txt
   └── pyproject.toml
```
3. **Set up virtual environment**
4. **Test with `python -m pytest`**
5. **Format with `black` and lint with `ruff`**
6. **Copy to `/mnt/user-data/outputs/`** for delivery

Example workflow:
```bash
# Create project structure
mkdir -p /home/claude/myapp/src/myapp
mkdir -p /home/claude/myapp/tests

# Create virtual environment
cd /home/claude/myapp
python -m venv .venv
source .venv/bin/activate

# Create files
create_file /home/claude/myapp/src/myapp/__init__.py
create_file /home/claude/myapp/src/myapp/main.py
create_file /home/claude/myapp/requirements.txt

# Install dependencies
pip install -r requirements.txt

# Format and lint
black src/
ruff check src/

# Run tests
pytest tests/

# Copy to outputs
cp -r /home/claude/myapp /mnt/user-data/outputs/
```

## Essential Python Commands
```bash
# Virtual environment
python -m venv .venv              # Create venv
source .venv/bin/activate         # Activate (Linux/Mac)
.venv\Scripts\activate            # Activate (Windows)
deactivate                        # Deactivate

# Package management
pip install package               # Install package
pip install -r requirements.txt   # Install from file
pip freeze > requirements.txt     # Export dependencies
pip list                          # List installed packages
pip show package                  # Show package info

# Running Python
python script.py                  # Run script
python -m module                  # Run module
python -i script.py               # Interactive after script
python -c "print('hello')"        # Run command

# Testing
pytest                            # Run all tests
pytest tests/test_file.py         # Run specific file
pytest -v                         # Verbose
pytest -k "test_name"             # Run by name pattern
pytest --cov=mypackage            # With coverage

# Code quality
black .                           # Format code
ruff check .                      # Lint code
mypy .                            # Type check
pylint mypackage                  # Comprehensive linting

# Package building
python -m build                   # Build package
pip install -e .                  # Install in editable mode

# Other
python --version                  # Python version
python -m site                    # Show site packages
python -m pydoc module            # View documentation
```

## Resources

- Official Documentation: https://docs.python.org/3/
- Python Package Index (PyPI): https://pypi.org/
- Python Enhancement Proposals (PEPs): https://peps.python.org/
- Real Python Tutorials: https://realpython.com/
- Python Style Guide (PEP 8): https://pep8.org/
- Python Testing: https://docs.pytest.org/

---

**Remember:** Python values readability and simplicity. Follow PEP 8 style guidelines, use type hints for clarity, write comprehensive tests, and leverage Python's rich standard library and ecosystem. When in doubt, "There should be one-- and preferably only one --obvious way to do it."
