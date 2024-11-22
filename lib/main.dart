import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'zaposlen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'vreme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialziacija firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  // Registriranje adapterjev
  Hive.registerAdapter(ZaposlenAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  await Hive.openBox<Zaposlen>('Zaposleni');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikacija za delavce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EmployeeFormPage(),
    );
  }
}

class EmployeeFormPage extends StatefulWidget {
  const EmployeeFormPage({super.key});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  String? _selectedJobTitle;
  DateTime? _birthDate;
  TimeOfDay? _arrivalTime;
  TimeOfDay? _departureTime;

  final List<String> _jobTitles = [
    'Električar',
    'Arhitekt',
    'Zdravnik',
    'Programer',
  ];

  // Inicializacija za hive
  late Box<Zaposlen> _employeesBox;

  @override
  void initState() {
    super.initState();
    _employeesBox = Hive.box<Zaposlen>('Zaposleni');
  }

  // Funkcija za izbiro datuma rojstva
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  // Funkcija za izbiro časa
  Future<void> _selectTime(BuildContext context, bool isArrivalTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isArrivalTime) {
          _arrivalTime = picked;
        } else {
          _departureTime = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    return date != null
        ? '${date.day}/${date.month}/${date.year}'
        : 'Select Date';
  }

  String _formatTime(TimeOfDay? time) {
    return time != null ? time.format(context) : 'Select Time';
  }

  Future<void> _saveEmployee() async {
    final zaposlen = Zaposlen(
      name: _nameController.text,
      surname: _surnameController.text,
      position: _selectedJobTitle ?? '',
      birthDate: _birthDate ?? DateTime.now(),
      arrivalTime: _arrivalTime ?? TimeOfDay.now(),
      departureTime: _departureTime ?? TimeOfDay.now(),
    );

    // Shranjevanje zaposlenega na hive
    await _employeesBox.add(zaposlen);

    setState(() {
      _nameController.clear();
      _surnameController.clear();
      _selectedJobTitle = null;
      _birthDate = null;
      _arrivalTime = null;
      _departureTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vnosno polje delavci'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
            onPressed: () {
              // Navigacija na vreme page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              // Navigacija na zaposleni page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployeeListPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              // Navigacija na login page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Vnosna polja za ime, sluzba
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ime'),
            ),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Priimek'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedJobTitle,
              items: _jobTitles.map((String jobTitle) {
                return DropdownMenuItem<String>(
                  value: jobTitle,
                  child: Text(jobTitle),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedJobTitle = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'Delovno mesto'),
            ),
            ListTile(
              title: Text('Datum rojstva: ${_formatDate(_birthDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectBirthDate(context),
            ),
            ListTile(
              title: Text('Ura prihoda: ${_formatTime(_arrivalTime)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text('Ura odhoda: ${_formatTime(_departureTime)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEmployee,
              child: const Text('Shrani podatke'),
            ),
          ],
        ),
      ),
    );
  }
}

// Vnasanje podatkov za zaposlene page
class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Zaposlen> employeesBox = Hive.box<Zaposlen>('Zaposleni');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seznam zaposlenih'),
      ),
      body: ValueListenableBuilder<Box<Zaposlen>>(
        valueListenable: employeesBox.listenable(),
        builder: (context, box, _) {
          final employees = box.values.toList();

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final zaposlen = employees[index];
              return ListTile(
                title: Text('${zaposlen.name} ${zaposlen.surname}'),
                subtitle: Text('Position: ${zaposlen.position}'),
              );
            },
          );
        },
      ),
    );
  }
}
