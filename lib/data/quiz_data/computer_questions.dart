import 'package:quiz_app/models/question.dart';

const List<Question> computerQuestions = [
  Question(
    question: 'What does CPU stand for?',
    options: [
      'Central Processing Unit',
      'Core Program Utility',
      'Computer Personal Unit',
      'Central Program Unit',
    ],
    answer: 'Central Processing Unit',
    note: 'The CPU (Central Processing Unit) is the primary chip that executes instructions in a computer.',
  ),
  Question(
    question: 'Which data structure follows the FIFO principle?',
    options: ['Stack', 'Tree', 'Queue', 'Graph'],
    answer: 'Queue',
    note: 'A Queue follows First In, First Out (FIFO) — the first element added is the first to be removed.',
  ),
  Question(
    question: 'What is the time complexity of binary search?',
    options: ['O(n)', 'O(n²)', 'O(log n)', 'O(1)'],
    answer: 'O(log n)',
    note: 'Binary search halves the search space each step, giving O(log n) time complexity.',
  ),
  Question(
    question: 'Which number system uses only digits 0 and 1?',
    options: ['Decimal', 'Octal', 'Hexadecimal', 'Binary'],
    answer: 'Binary',
    note: 'The binary (base-2) number system uses only 0 and 1, the native language of computers.',
  ),
  Question(
    question: 'What does RAM stand for?',
    options: [
      'Random Access Memory',
      'Read Allocated Memory',
      'Rapid Application Module',
      'Runtime Access Module',
    ],
    answer: 'Random Access Memory',
    note: 'RAM (Random Access Memory) is volatile memory used to store data the CPU is actively working with.',
  ),
  Question(
    question: 'Which layer of the OSI model is responsible for routing?',
    options: ['Data Link', 'Transport', 'Network', 'Session'],
    answer: 'Network',
    note: 'The Network layer (Layer 3) handles logical addressing and routing of packets between networks.',
  ),
  Question(
    question: 'What does HTTP stand for?',
    options: [
      'HyperText Transfer Protocol',
      'High Transfer Text Program',
      'Host Text Transmission Protocol',
      'HyperText Transmission Program',
    ],
    answer: 'HyperText Transfer Protocol',
    note: 'HTTP (HyperText Transfer Protocol) is the protocol used for communication on the World Wide Web.',
  ),
  Question(
    question: 'Which of these is NOT an object-oriented programming language?',
    options: ['Java', 'C++', 'Python', 'C'],
    answer: 'C',
    note: 'C is a procedural language. Java, C++, and Python all support object-oriented programming.',
  ),
  Question(
    question: 'What does an AND gate output when one input is 0?',
    options: ['1', '0', 'Depends on other input', 'Undefined'],
    answer: '0',
    note: 'An AND gate outputs 1 only when ALL inputs are 1. If any input is 0, the output is always 0.',
  ),
  Question(
    question: 'Which storage type retains data without power?',
    options: ['RAM', 'Cache', 'CPU Register', 'ROM'],
    answer: 'ROM',
    note: 'ROM (Read-Only Memory) is non-volatile — it retains data even when the power is off, unlike RAM.',
  ),
];
