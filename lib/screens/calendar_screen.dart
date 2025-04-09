import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/event_model.dart';
import 'package:notes_app/providers/calendar_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<CalendarProvider>(
          builder: (context, calendarProvider, _) => TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              return calendarProvider.getEventsForDay(day);
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              markersMaxCount: 3,
              markerDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: const Icon(Icons.chevron_left),
              rightChevronIcon: const Icon(Icons.chevron_right),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Consumer<CalendarProvider>(
            builder: (context, calendarProvider, _) {
              final events = calendarProvider.getEventsForDay(_selectedDay);

              return events.isEmpty
                  ? const Center(child: Text('這一天沒有事件'))
                  : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _buildEventCard(context, event);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description.isNotEmpty) Text(event.description),
            if (!event.isAllDay && event.startTime != null)
              Text(
                '時間: ${timeFormat.format(event.startTime!)}${event.endTime != null ? ' - ${timeFormat.format(event.endTime!)}' : ''}',
              ),
          ],
        ),
        leading: Container(
          width: 12,
          height: double.infinity,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () => _showEventDetails(event),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteEvent(event),
        ),
      ),
    );
  }

  void _showEventDetails(Event event) {
    // 顯示事件詳情，並提供編輯選項
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (event.description.isNotEmpty) ...[
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
              ],
              Text(
                '日期: ${DateFormat('yyyy-MM-dd').format(event.date)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (!event.isAllDay && event.startTime != null) ...[
                Text(
                  '時間: ${DateFormat('HH:mm').format(event.startTime!)}${event.endTime != null ? ' - ${DateFormat('HH:mm').format(event.endTime!)}' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _editEvent(event);
                    },
                    child: const Text('編輯'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('關閉'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _editEvent(Event event) {
    // 實作編輯事件的邏輯
    // 這個功能可以調用另一個顯示編輯表單的方法，或導航到編輯頁面
  }

  Future<void> _deleteEvent(Event event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除事件'),
        content: const Text('確定要刪除這個事件嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('刪除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final calendarProvider = Provider.of<CalendarProvider>(
          context,
          listen: false
      );
      await calendarProvider.deleteEvent(event.id!);
    }
  }
}