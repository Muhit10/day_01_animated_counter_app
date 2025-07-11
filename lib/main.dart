import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AnimatedCounterApp());
}

class AnimatedCounterApp extends StatelessWidget {
  const AnimatedCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CounterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen>
    with TickerProviderStateMixin {
  int _counter = 0;
  
  
  late AnimationController _decrementBounceController;
  late AnimationController _resetBounceController;
  late AnimationController _incrementBounceController;
  late AnimationController _pulseController;
  
 
  late Animation<double> _decrementBounceAnimation;
  late Animation<double> _resetBounceAnimation;
  late Animation<double> _incrementBounceAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    
    _decrementBounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _resetBounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _incrementBounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // bounce animations
    _decrementBounceAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _decrementBounceController, curve: Curves.easeInOut),
    );
    _resetBounceAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _resetBounceController, curve: Curves.easeInOut),
    );
    _incrementBounceAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _incrementBounceController, curve: Curves.easeInOut),
    );

    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _decrementBounceController.dispose();
    _resetBounceController.dispose();
    _incrementBounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // increment counter function
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _triggerPulseAnimation();
  }

  // decrement function
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
    _triggerPulseAnimation();
  }

  // reset function
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _triggerPulseAnimation();
  }

  void _triggerPulseAnimation() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  // আলাদা bounce animation trigger functions
  void _triggerDecrementBounceAnimation() {
    _decrementBounceController.forward().then((_) {
      _decrementBounceController.reverse();
    });
  }

  void _triggerResetBounceAnimation() {
    _resetBounceController.forward().then((_) {
      _resetBounceController.reverse();
    });
  }

  void _triggerIncrementBounceAnimation() {
    _incrementBounceController.forward().then((_) {
      _incrementBounceController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Title
                    Text(
                      'Animated Counter',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 36 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Counter Display with Animation
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: isTablet ? 200 : 150,
                            height: isTablet ? 200 : 150,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  _counter.toString(),
                                  key: ValueKey<int>(_counter),
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 48 : 36,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF667eea),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 80),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Decrement Button
                        _buildAnimatedButton(
                          icon: Icons.remove,
                          onPressed: _decrementCounter,
                          color: Colors.red,
                          size: isTablet ? 70 : 60,
                          animation: _decrementBounceAnimation,
                          onTapDown: _triggerDecrementBounceAnimation,
                        ),

                        // Reset Button
                        _buildAnimatedButton(
                          icon: Icons.refresh,
                          onPressed: _resetCounter,
                          color: Colors.orange,
                          size: isTablet ? 70 : 60,
                          animation: _resetBounceAnimation,
                          onTapDown: _triggerResetBounceAnimation,
                        ),

                        // Increment Button
                        _buildAnimatedButton(
                          icon: Icons.add,
                          onPressed: _incrementCounter,
                          color: Colors.green,
                          size: isTablet ? 70 : 60,
                          animation: _incrementBounceAnimation,
                          onTapDown: _triggerIncrementBounceAnimation,
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Counter Info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _counter == 0
                            ? 'Start counting!'
                            : _counter > 0
                                ? 'Positive: $_counter'
                                : 'Negative: $_counter',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required double size,
    required Animation<double> animation,
    required VoidCallback onTapDown,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: GestureDetector(
            onTapDown: (_) => onTapDown(),
            onTap: onPressed,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(size / 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.8),
                    color,
                  ],
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: size * 0.4,
              ),
            ),
          ),
        );
      },
    );
  }
}