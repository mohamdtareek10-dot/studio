import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق قائمة المهام',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const TodoListScreen(),
    );
  }
}

// نموذج المهمة
class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  DateTime? dueDate;
  String priority; // high, medium, low

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = 'medium',
  });

  // تحويل المهمة إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
    };
  }

  // إنشاء مهمة من JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      priority: json['priority'] as String? ?? 'medium',
    );
  }
}

// الخدمة المسؤولة عن التخزين المحلي
class TodoService {
  static const String _storageKey = 'todos_list';
  static final TodoService _instance = TodoService._internal();

  factory TodoService() {
    return _instance;
  }

  TodoService._internal();

  // حفظ المهام في التخزين المحلي
  Future<void> saveTodos(List<Todo> todos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
      await prefs.setStringList(_storageKey, jsonList);
      print('✅ تم حفظ ${todos.length} مهام بنجاح');
    } catch (e) {
      print('❌ خطأ في حفظ المهام: $e');
    }
  }

  // تحميل المهام من التخزين المحلي
  Future<List<Todo>> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_storageKey) ?? [];
      final todos = jsonList
          .map((jsonString) => Todo.fromJson(jsonDecode(jsonString) as Map<String, dynamic>))
          .toList();
      print('✅ تم تحميل ${todos.length} مهام بنجاح');
      return todos;
    } catch (e) {
      print('❌ خطأ في تحميل المهام: $e');
      return [];
    }
  }

  // إضافة مهمة جديدة
  Future<void> addTodo(Todo todo) async {
    final todos = await loadTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  // تحديث مهمة
  Future<void> updateTodo(Todo updatedTodo) async {
    final todos = await loadTodos();
    final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      todos[index] = updatedTodo;
      await saveTodos(todos);
    }
  }

  // حذف مهمة
  Future<void> deleteTodo(String todoId) async {
    final todos = await loadTodos();
    todos.removeWhere((todo) => todo.id == todoId);
    await saveTodos(todos);
  }

  // مسح جميع المهام
  Future<void> clearAllTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    print('✅ تم مسح جميع المهام');
  }
}

// الشاشة الرئيسية
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  bool _isLoading = true;
  String _filterType = 'all'; // all, completed, pending

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() => _isLoading = true);
    final todos = await _todoService.loadTodos();
    setState(() {
      _todos = todos;
      _isLoading = false;
    });
  }

  List<Todo> _getFilteredTodos() {
    switch (_filterType) {
      case 'completed':
        return _todos.where((todo) => todo.isCompleted).toList();
      case 'pending':
        return _todos.where((todo) => !todo.isCompleted).toList();
      default:
        return _todos;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'high':
        return 'أولوية عالية';
      case 'medium':
        return 'أولوية متوسطة';
      case 'low':
        return 'أولوية منخفضة';
      default:
        return 'عادي';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _getFilteredTodos();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('📝 قائمة المهام', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0284C7),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : Column(
              children: [
                // شريط التصفية
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      _buildFilterButton('الكل', 'all'),
                      const SizedBox(width: 10),
                      _buildFilterButton('قيد الإنجاز', 'pending'),
                      const SizedBox(width: 10),
                      _buildFilterButton('مكتملة', 'completed'),
                    ],
                  ),
                ),
                // عداد المهام
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('إجمالي المهام', _todos.length.toString(), Colors.blue),
                        _buildStatCard('مكتملة', _todos.where((t) => t.isCompleted).length.toString(), Colors.green),
                        _buildStatCard('قيد الإنجاز', _todos.where((t) => !t.isCompleted).length.toString(), Colors.orange),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // قائمة المهام
                Expanded(
                  child: filteredTodos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 80, color: Colors.grey.withOpacity(0.5)),
                              const SizedBox(height: 15),
                              Text(
                                _filterType == 'completed' ? 'لا توجد مهام مكتملة' : 'لا توجد مهام قيد الإنجاز',
                                style: const TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];
                            return _buildTodoCard(todo);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0284C7),
        onPressed: () => _showAddTodoDialog(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildFilterButton(String label, String type) {
    final isActive = _filterType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filterType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTodoCard(Todo todo) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) async {
            todo.isCompleted = !todo.isCompleted;
            await _todoService.updateTodo(todo);
            await _loadTodos();
          },
          activeColor: Colors.green,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              todo.description,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(todo.priority).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _getPriorityLabel(todo.priority),
                    style: TextStyle(
                      color: _getPriorityColor(todo.priority),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (todo.dueDate != null)
                  Text(
                    '📅 ${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          color: const Color(0xFF1E293B),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue, size: 18),
                  SizedBox(width: 10),
                  Text('تعديل', style: TextStyle(color: Colors.white)),
                ],
              ),
              onTap: () => _showEditTodoDialog(todo),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 18),
                  SizedBox(width: 10),
                  Text('حذف', style: TextStyle(color: Colors.white)),
                ],
              ),
              onTap: () => _deleteTodo(todo.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTodoDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedPriority = 'medium';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('إضافة مهمة جديدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'عنوان المهمة',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'وصف المهمة',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('الأولوية:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  dropdownColor: const Color(0xFF0F172A),
                  value: selectedPriority,
                  isExpanded: true,
                  items: ['low', 'medium', 'high'].map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value == 'high' ? '🔴 أولوية عالية' : value == 'medium' ? '🟠 أولوية متوسطة' : '🟢 أولوية منخفضة',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedPriority = value!);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null ? 'لم يتم تحديد تاريخ' : '📅 ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => selectedDate = date);
                        }
                      },
                      child: const Text('اختيار تاريخ', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final newTodo = Todo(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                    createdAt: DateTime.now(),
                    dueDate: selectedDate,
                    priority: selectedPriority,
                  );
                  await _todoService.addTodo(newTodo);
                  await _loadTodos();
                  if (mounted) Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يجب إدخال عنوان المهمة'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('إضافة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTodoDialog(Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);
    String selectedPriority = todo.priority;
    DateTime? selectedDate = todo.dueDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('تعديل المهمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'عنوان المهمة',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'وصف المهمة',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('الأولوية:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  dropdownColor: const Color(0xFF0F172A),
                  value: selectedPriority,
                  isExpanded: true,
                  items: ['low', 'medium', 'high'].map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value == 'high' ? '🔴 أولوية عالية' : value == 'medium' ? '🟠 أولوية متوسطة' : '🟢 أولوية منخفضة',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedPriority = value!);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null ? 'لم يتم تحديد تاريخ' : '📅 ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => selectedDate = date);
                        }
                      },
                      child: const Text('اختيار تاريخ', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final updatedTodo = Todo(
                    id: todo.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: todo.isCompleted,
                    createdAt: todo.createdAt,
                    dueDate: selectedDate,
                    priority: selectedPriority,
                  );
                  await _todoService.updateTodo(updatedTodo);
                  await _loadTodos();
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('تحديث', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTodo(String todoId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('هل أنت متأكد من حذف هذه المهمة؟', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _todoService.deleteTodo(todoId);
              await _loadTodos();
              if (mounted) Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
