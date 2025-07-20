import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // Import for Uuid
import 'package:intl/intl.dart'; // For date formatting

// --- CONSTANTS for New Color Scheme ---
const Color bsuRed = Color(0xFFC00000); // Main red from the website
const Color bsuDark = Color(0xFF212121); // Dark grey for backgrounds/appbar
const Color bsuLightGrey = Color(0xFFF5F5F5); // Light grey for scaffold
const Color bsuTextOnLight = Color(0xFF333333); // Dark text for light backgrounds
const Color bsuSuccessGreen = Color(0xFF2E7D32); // A suitable green for success states

// --- MODELS ---
class LicensePlate {
  final String id;
  String plateNumber;
  String ownerName;
  String contactNumber;
  final DateTime dateAdded;

  LicensePlate({
    required this.id,
    required this.plateNumber,
    required this.ownerName,
    required this.contactNumber,
    required this.dateAdded,
  });
}

class RecognitionLog {
  final String plateNumber;
  final DateTime timestamp;
  final bool isRegistered;

  RecognitionLog({
    required this.plateNumber,
    required this.timestamp,
    required this.isRegistered,
  });
}

// --- MOCK API SERVICE ---
// Simulates a backend service for data management.
class MockApiService {
  final List<LicensePlate> _plates = [
    LicensePlate(id: '1', plateNumber: 'ABC123', ownerName: 'John Doe', contactNumber: '0917-123-4567', dateAdded: DateTime.now().subtract(const Duration(days: 5))),
    LicensePlate(id: '2', plateNumber: 'XYZ789', ownerName: 'Jane Smith', contactNumber: '0928-987-6543', dateAdded: DateTime.now().subtract(const Duration(days: 10))),
    LicensePlate(id: '3', plateNumber: 'LMN456', ownerName: 'Mike Cruz', contactNumber: '0933-456-7890', dateAdded: DateTime.now().subtract(const Duration(days: 2))),
    LicensePlate(id: '4', plateNumber: 'QWE007', ownerName: 'Alice Wonderland', contactNumber: '0945-111-2222', dateAdded: DateTime.now().subtract(const Duration(days: 1))),
    LicensePlate(id: '5', plateNumber: 'RTY987', ownerName: 'Bob The Builder', contactNumber: '0966-333-4444', dateAdded: DateTime.now().subtract(const Duration(days: 7))),
     LicensePlate(id: '6', plateNumber: 'NVM555', ownerName: 'Nancy Wheeler', contactNumber: '0918-111-2222', dateAdded: DateTime.now().subtract(const Duration(days: 12))),
    LicensePlate(id: '7', plateNumber: 'STV777', ownerName: 'Steve Harrington', contactNumber: '0919-222-3333', dateAdded: DateTime.now().subtract(const Duration(days: 15))),
    LicensePlate(id: '8', plateNumber: 'HPR888', ownerName: 'Jim Hopper', contactNumber: '0920-333-4444', dateAdded: DateTime.now().subtract(const Duration(days: 20))),
    LicensePlate(id: '9', plateNumber: 'BYR999', ownerName: 'Joyce Byers', contactNumber: '0921-444-5555', dateAdded: DateTime.now().subtract(const Duration(days: 22))),
    LicensePlate(id: '10', plateNumber: 'ELV011', ownerName: 'Eleven', contactNumber: '0922-555-6666', dateAdded: DateTime.now().subtract(const Duration(days: 25))),
    LicensePlate(id: '11', plateNumber: 'WLH121', ownerName: 'Will Byers', contactNumber: '0923-666-7777', dateAdded: DateTime.now().subtract(const Duration(days: 30))),
    LicensePlate(id: '12', plateNumber: 'DSC232', ownerName: 'Dustin Henderson', contactNumber: '0924-777-8888', dateAdded: DateTime.now().subtract(const Duration(days: 31))),

  ];

  final List<RecognitionLog> _logs = [
    RecognitionLog(plateNumber: 'ABC123', timestamp: DateTime.now().subtract(const Duration(hours: 1)), isRegistered: true),
    RecognitionLog(plateNumber: 'TEST00', timestamp: DateTime.now().subtract(const Duration(hours: 2)), isRegistered: false),
    RecognitionLog(plateNumber: 'XYZ789', timestamp: DateTime.now().subtract(const Duration(hours: 5)), isRegistered: true),
    RecognitionLog(plateNumber: 'UNREG1', timestamp: DateTime.now().subtract(const Duration(minutes: 30)), isRegistered: false),
    RecognitionLog(plateNumber: 'QWE007', timestamp: DateTime.now().subtract(const Duration(minutes: 15)), isRegistered: true),
    RecognitionLog(plateNumber: 'LMN456', timestamp: DateTime.now().subtract(const Duration(minutes: 45)), isRegistered: true),
  ];

  Future<List<LicensePlate>> getPlates() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network latency
    return List.from(_plates);
  }

  Future<LicensePlate> addPlate(String plate, String name, String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newPlate = LicensePlate(
      id: const Uuid().v4(), // Use UUID for unique ID generation
      plateNumber: plate,
      ownerName: name,
      contactNumber: phone,
      dateAdded: DateTime.now(),
    );
    _plates.add(newPlate);
    return newPlate;
  }

  Future<void> updatePlate(String id, String plate, String name, String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _plates.indexWhere((p) => p.id == id);
    if (index != -1) {
      _plates[index] = LicensePlate(
        id: id,
        plateNumber: plate,
        ownerName: name,
        contactNumber: phone,
        dateAdded: _plates[index].dateAdded,
      );
    }
  }

  Future<void> deletePlate(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _plates.removeWhere((p) => p.id == id);
  }

  Future<List<RecognitionLog>> getRecognitionLogs() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_logs);
  }
}

// --- PROVIDERS (State Management) ---
class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String username, String password) async {
    // Simulate API call for authentication
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'admin' && password == 'password') {
      _isAuthenticated = true;
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

class PlateProvider with ChangeNotifier {
  final MockApiService _apiService;
  List<LicensePlate> _plates = [];
  List<RecognitionLog> _logs = [];
  bool isLoading = false;

  PlateProvider(this._apiService) {
    fetchData();
  }

  List<LicensePlate> get plates => _plates;
  List<RecognitionLog> get logs => _logs;
  int get totalPlates => _plates.length;

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    _plates = await _apiService.getPlates();
    _logs = await _apiService.getRecognitionLogs();
    _plates.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    _logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    isLoading = false;
    notifyListeners();
  }

  Future<void> addPlate(String plate, String name, String phone) async {
    await _apiService.addPlate(plate, name, phone);
    await fetchData();
  }

  Future<void> updatePlate(String id, String plate, String name, String phone) async {
    await _apiService.updatePlate(id, plate, name, phone);
    await fetchData();
  }

  Future<void> deletePlate(String id) async {
    await _apiService.deletePlate(id);
    await fetchData();
  }
}

// --- MAIN APP ---
void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlateProvider(MockApiService())),
      ],
      child: MaterialApp(
        title: 'ALPR Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: bsuDark,
          scaffoldBackgroundColor: bsuLightGrey,
          // New color scheme based on the website
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            accentColor: bsuRed,
            brightness: Brightness.light,
          ).copyWith(
            primary: bsuRed,
            secondary: bsuSuccessGreen,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: bsuTextOnLight,
            error: const Color(0xFFD32F2F),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: bsuRed,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: Colors.black38,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: bsuTextOnLight),
            displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: bsuTextOnLight),
            displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: bsuTextOnLight),
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: bsuTextOnLight),
            headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: bsuTextOnLight),
            headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: bsuTextOnLight),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: bsuTextOnLight),
            titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: bsuTextOnLight),
            titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: bsuTextOnLight),
            bodyLarge: TextStyle(fontSize: 16, color: bsuTextOnLight),
            bodyMedium: TextStyle(fontSize: 14, color: bsuTextOnLight),
            bodySmall: TextStyle(fontSize: 12, color: Color(0xFF757575)), // Grey for subtitles
            labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          cardTheme: CardThemeData(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(8),
            shadowColor: Colors.black12,
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: bsuRed, width: 2),
            ),
            labelStyle: const TextStyle(color: Color(0xFF757575)),
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: bsuRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              shadowColor: bsuRed.withOpacity(0.4),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: bsuTextOnLight,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: bsuTextOnLight,
              side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          navigationRailTheme: NavigationRailThemeData(
            backgroundColor: bsuDark,
            selectedIconTheme: const IconThemeData(color: bsuRed, size: 30),
            unselectedIconTheme: const IconThemeData(color: Colors.white70, size: 28),
            selectedLabelTextStyle: const TextStyle(color: bsuRed, fontWeight: FontWeight.bold),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            indicatorColor: bsuRed.withOpacity(0.2),
            elevation: 10,
            groupAlignment: -0.9,
          ),
          dataTableTheme: DataTableThemeData(
            headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
            dataRowColor: WidgetStateProperty.all(Colors.white),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: bsuTextOnLight, fontSize: 15),
            dataTextStyle: const TextStyle(color: bsuTextOnLight, fontSize: 14),
            columnSpacing: 30,
            horizontalMargin: 20,
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(bsuRed.withOpacity(0.7)),
            trackColor: WidgetStateProperty.all(Colors.grey.shade200),
            thickness: WidgetStateProperty.all(8),
            radius: const Radius.circular(10),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: auth.isAuthenticated
                  ? const MainScreen(key: ValueKey('MainScreen'))
                  : const LoginPage(key: ValueKey('LoginPage')),
            );
          },
        ),
      ),
    );
  }
}

// --- SCREENS ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _userController = TextEditingController(text: 'admin');
  final _passController = TextEditingController(text: 'password');
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_userController.text, _passController.text);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/Alangilan-CIT.jpg', // Placeholder image URL
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Text(
                      'Could not load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          // Overlay for readability
          Container(
            color: Colors.black.withOpacity(0.5), // Dark overlay for text readability
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                    children: [
                      Text(
                        'ALPR Admin Panel',
                        textAlign: TextAlign.right, // Align text to the right
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Batangas State University - Alangilan Campus',
                        textAlign: TextAlign.right, // Align text to the right
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black.withOpacity(0.4),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50), // Spacing between title and login box
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Replaced Icon with Image.asset
                              Image.asset(
                                'images/logo.png', // Path to your local image
                                width: 80, // Adjust size as needed
                                height: 80, // Adjust size as needed
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.error,
                                    size: 80,
                                    color: Theme.of(context).colorScheme.error,
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'ALPR Admin Login',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 30),
                              TextField(
                                controller: _userController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _passController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 30),
                              if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              _isLoading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _login,
                                        child: const Text('Login'),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 200), // Spacing to the right of the login box
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DatabaseScreen(),
    const MonitoringScreen(),
  ];

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Logout Confirmation', style: Theme.of(context).textTheme.titleLarge),
        content: const Text('Are you sure you want to logout from the Admin Panel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALPR Administrator Panel'),
        actions: [
          Tooltip(
            message: 'Refresh Data',
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                context.read<PlateProvider>().fetchData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data refreshed!')),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Logout',
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.storage_outlined),
                selectedIcon: Icon(Icons.storage),
                label: Text('Database'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.monitor_heart_outlined),
                selectedIcon: Icon(Icons.monitor_heart),
                label: Text('Monitoring'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1, color: Colors.grey.shade300),
          Expanded(
            child: Consumer<PlateProvider>(
              builder: (context, provider, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: provider.isLoading
                      ? Center(
                          key: const ValueKey('loading'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(height: 16),
                              Text('Loading data...', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        )
                      : _screens[_selectedIndex],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plateProvider = context.watch<PlateProvider>();
    final recentPlates = plateProvider.plates.take(5).toList();
    final recentLogs = plateProvider.logs.take(5).toList();
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _animation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard Overview', style: theme.textTheme.headlineLarge),
            const SizedBox(height: 30),
            Wrap(
              spacing: 30,
              runSpacing: 30,
              children: [
                _buildStatCard(
                  context,
                  icon: Icons.directions_car,
                  label: 'Total Registered Plates',
                  value: plateProvider.totalPlates.toString(),
                  color: theme.colorScheme.primary,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.history,
                  label: 'Total Recognition Logs',
                  value: plateProvider.logs.length.toString(),
                  color: Colors.blue.shade700,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Registered Recognitions',
                  value: plateProvider.logs.where((log) => log.isRegistered).length.toString(),
                  color: theme.colorScheme.secondary,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.cancel_outlined,
                  label: 'Unrecognized Plates',
                  value: plateProvider.logs.where((log) => !log.isRegistered).length.toString(),
                  color: Colors.orange.shade700,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildRecentActivityList(
                    context,
                    title: 'Recently Added Plates',
                    items: recentPlates.asMap().entries.map((entry) {
                      int index = entry.key;
                      LicensePlate p = entry.value;
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(0.5 + (index * 0.1), 1.0, curve: Curves.easeOut),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Icon(Icons.label_important, color: theme.colorScheme.primary),
                          ),
                          title: Text(p.plateNumber, style: theme.textTheme.titleMedium),
                          subtitle: Text(p.ownerName, style: theme.textTheme.bodyMedium),
                          trailing: Text(DateFormat('MMM dd, yyyy').format(p.dateAdded), style: theme.textTheme.bodySmall),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: _buildRecentActivityList(
                    context,
                    title: 'Recent Recognition Events',
                    items: recentLogs.asMap().entries.map((entry) {
                      int index = entry.key;
                      RecognitionLog log = entry.value;
                      final isRegistered = log.isRegistered;
                      final color = isRegistered ? theme.colorScheme.secondary : Colors.orange.shade700;
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(0.5 + (index * 0.1), 1.0, curve: Curves.easeOut),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.1),
                            child: Icon(
                              isRegistered ? Icons.check_circle : Icons.cancel,
                              color: color,
                            ),
                          ),
                          title: Text(log.plateNumber, style: theme.textTheme.titleMedium),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy HH:mm').format(log.timestamp.toLocal()),
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: Chip(
                            label: Text(isRegistered ? 'Registered' : 'Unrecognized', style: const TextStyle(color: Colors.white, fontSize: 12)),
                            backgroundColor: color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 350),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 36),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(value, style: theme.textTheme.headlineMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context, {required String title, required List<Widget> items}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(title, style: theme.textTheme.headlineSmall),
          ),
          Divider(height: 1, thickness: 1, indent: 20, endIndent: 20, color: theme.scaffoldBackgroundColor),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No recent activity to display.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) => items[index],
            ),
        ],
      ),
    );
  }
}

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showEditDialog({LicensePlate? plate}) {
    showDialog(
      context: context,
      builder: (_) => AddEditPlateDialog(plate: plate),
    );
  }

  void _showDeleteDialog(LicensePlate plate) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Confirm Deletion', style: theme.textTheme.titleLarge),
        content: Text('Are you sure you want to delete the license plate "${plate.plateNumber}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PlateProvider>().deletePlate(plate.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Plate ${plate.plateNumber} deleted successfully.'),
                    backgroundColor: theme.colorScheme.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(15),
                  ),
                );
            },
            style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plateProvider = context.watch<PlateProvider>();
    final allPlates = plateProvider.plates;
    final query = _searchController.text.toLowerCase();
    final theme = Theme.of(context);

    final filteredPlates = allPlates.where((plate) {
      return plate.plateNumber.toLowerCase().contains(query) ||
          plate.ownerName.toLowerCase().contains(query) ||
          plate.contactNumber.toLowerCase().contains(query);
    }).toList();

    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Plates (Number, Owner, Contact)',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add New Plate'),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.antiAlias,
                // Using a SingleChildScrollView to prevent overflow on smaller screens,
                // while keeping the pagination functionality of the PaginatedDataTable.
                child: SingleChildScrollView(
                  child: filteredPlates.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, size: 60, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  'No registered plates found matching your search.',
                                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : PaginatedDataTable(
                          key: ValueKey(filteredPlates.length),
                          header: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Registered Plates Database',
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                          columns: const [
                            DataColumn(label: Text('Plate Number')),
                            DataColumn(label: Text('Owner Name')),
                            DataColumn(label: Text('Contact Number')),
                            DataColumn(label: Text('Date Added')),
                            DataColumn(label: Text('Actions')),
                          ],
                          source: _PlateDataSource(
                            plates: filteredPlates,
                            onEdit: (plate) => _showEditDialog(plate: plate),
                            onDelete: _showDeleteDialog,
                            theme: theme,
                          ),
                          rowsPerPage: 10,
                          showCheckboxColumn: false,
                          columnSpacing: 40,
                          horizontalMargin: 20,
                          headingRowHeight: 60,
                          dataRowMinHeight: 50,
                          dataRowMaxHeight: 60,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlateDataSource extends DataTableSource {
  final List<LicensePlate> plates;
  final Function(LicensePlate) onEdit;
  final Function(LicensePlate) onDelete;
  final ThemeData theme;

  _PlateDataSource({required this.plates, required this.onEdit, required this.onDelete, required this.theme});

  @override
  DataRow? getRow(int index) {
    if (index >= plates.length) return null;
    final plate = plates[index];
    return DataRow(cells: [
      DataCell(Text(plate.plateNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(plate.ownerName)),
      DataCell(Text(plate.contactNumber)),
      DataCell(Text(DateFormat('MMM dd, yyyy').format(plate.dateAdded))),
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Edit Plate',
            child: IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              onPressed: () => onEdit(plate),
            ),
          ),
          Tooltip(
            message: 'Delete Plate',
            child: IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: () => onDelete(plate),
            ),
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => plates.length;
  @override
  int get selectedRowCount => 0;
}

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<PlateProvider>().logs;
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  'Real-time Recognition Logs',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              Divider(height: 1, thickness: 1, indent: 20, endIndent: 20, color: theme.scaffoldBackgroundColor),
              Expanded(
                child: logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monitor_heart_outlined, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No recognition logs available yet.',
                              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          final isRegistered = log.isRegistered;
                          final color = isRegistered ? theme.colorScheme.secondary : Colors.orange.shade700;
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: Interval(0.0 + (index * 0.1), 1.0, curve: Curves.easeOut),
                              ),
                            ),
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: color.withOpacity(0.1),
                                  child: Icon(
                                    isRegistered ? Icons.check_circle_outline : Icons.cancel_outlined,
                                    color: color,
                                  ),
                                ),
                                title: Text(
                                  log.plateNumber,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Timestamp: ${DateFormat('MMM dd, yyyy HH:mm:ss').format(log.timestamp.toLocal())}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                trailing: Chip(
                                  label: Text(
                                    isRegistered ? 'Registered' : 'Unrecognized',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                  backgroundColor: color,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS ---
class AddEditPlateDialog extends StatefulWidget {
  final LicensePlate? plate;
  const AddEditPlateDialog({super.key, this.plate});

  @override
  State<AddEditPlateDialog> createState() => _AddEditPlateDialogState();
}

class _AddEditPlateDialogState extends State<AddEditPlateDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _plateController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool get _isEditing => widget.plate != null;

  final RegExp _plateNumberRegExp = RegExp(r'^[A-Z]{2,3}\s?\d{3,5}$');

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.plate?.plateNumber ?? '');
    _nameController = TextEditingController(text: widget.plate?.ownerName ?? '');
    _phoneController = TextEditingController(text: widget.plate?.contactNumber ?? '');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final provider = context.read<PlateProvider>();
    final plateNumber = _plateController.text.trim().toUpperCase();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final theme = Theme.of(context);

    if (!_isEditing) {
      final isDuplicatePlate = provider.plates.any(
        (p) => p.plateNumber.toUpperCase() == plateNumber,
      );
      if (isDuplicatePlate) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Error: License plate "$plateNumber" already exists.'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(15),
          ));
        return;
      }
    } else {
      final existingPlatesExcludingCurrent = provider.plates.where((p) => p.id != widget.plate!.id).toList();

      final isDuplicatePlateOnEdit = existingPlatesExcludingCurrent.any(
        (p) => p.plateNumber.toUpperCase() == plateNumber,
      );
      if (isDuplicatePlateOnEdit) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Error: License plate "$plateNumber" already exists for another entry.'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(15),
          ));
        return;
      }
    }

    if (_isEditing) {
      provider.updatePlate(widget.plate!.id, plateNumber, name, phone);
    } else {
      provider.addPlate(plateNumber, name, phone);
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Entry ${_isEditing ? 'updated' : 'added'} successfully.'),
          backgroundColor: theme.colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(15),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          _isEditing ? 'Edit License Plate' : 'Add New License Plate',
          style: theme.textTheme.headlineSmall,
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _plateController,
                  decoration: const InputDecoration(
                    labelText: 'Plate Number',
                    hintText: 'e.g., ABC1234, AB 123',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Plate Number is required';
                    }
                    if (!_plateNumberRegExp.hasMatch(value.toUpperCase())) {
                      return 'Invalid plate format (e.g., ABC1234, AB 123)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Owner Name',
                    hintText: 'e.g., Juan Dela Cruz',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Owner Name is required' : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    hintText: 'e.g., 09171234567 or +639171234567',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Contact Number is required';
                    }
                    final phoneRegExp = RegExp(r'^(09|\+639)\d{9}$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'Enter a valid Philippine number (e.g., 09... or +639...)';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.all(20),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text(_isEditing ? 'Update Plate' : 'Add Plate'),
          ),
        ],
      ),
    );
  }
}