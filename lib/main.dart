import 'package:flutter/material.dart';

/// Точка входа в приложение.
void main() {
  runApp(const MyApp());
}

/// Основной виджет приложения, который создает Scaffold с виджетом Dock.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(
          child: Dock(
            items: [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

/// Виджет Dock — это контейнер для иконок, которые можно перетаскивать.
/// Принимает список иконок и позволяет перетаскивать их внутри контейнера.
class Dock extends StatefulWidget {
  const Dock({
    super.key,
    required this.items,
  });

  /// Список иконок, которые будут отображены в Dock.
  final List<IconData> items;

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  late List<IconData> _items; // Список иконок для отображения
  int? _draggingIndex; // Индекс иконки, которая в данный момент перетаскивается

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items); // Копируем список иконок из конструктора
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black38,
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _items.length,
          (index) {
            final icon = _items[index];
            return _buildDraggableItem(icon, index);
          },
        ),
      ),
    );
  }

  /// Метод для создания перетаскиваемого элемента.

  /// Создает LongPressDraggable для каждой иконки, чтобы ее можно было перетаскивать.
  Widget _buildDraggableItem(IconData icon, int index) {
    return LongPressDraggable<IconData>(
      data: icon,
      onDragStarted: () {
        setState(() {
          _draggingIndex = index; // Устанавливаем индекс перетаскиваемой иконки
        });
      },
      onDragEnd: (_) {
        setState(() {
          _draggingIndex =
              null; // Сбрасываем индекс после завершения перетаскивания
        });
      },
      feedback: Material(
        color: Colors.transparent,
        child: _buildDockItem(icon), // Показ иконки при перетаскивании
      ),
      child: DragTarget<IconData>(
        onWillAccept: (data) => data != null && _draggingIndex != index,
        onAccept: (data) {
          setState(() {
            final oldIndex = _items.indexOf(data);
            _items.removeAt(oldIndex);
            _items.insert(index, data); // Меняем местами иконки
          });
        },
        builder: (context, candidateData, rejectedData) {
          // Если иконка перетаскивается, скрываем её в исходном положении
          final isDragging = _draggingIndex == index;
          final isHovered = candidateData.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: isHovered ? 30 : 4),
            child: isDragging ? const SizedBox.shrink() : _buildDockItem(icon),
          );
        },
      ),
    );
  }

  /// Метод для построения одного элемента в доке (иконки).

  /// Принимает иконку и возвращает виджет, отображающий эту иконку в виде кнопки.
  Widget _buildDockItem(IconData icon) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48),
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[
            icon.hashCode % Colors.primaries.length], // Стандартный цвет
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
