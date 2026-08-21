import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class GenerateButton extends StatelessWidget {
  const GenerateButton({
    super.key,
    required this.onTap,
    required this.isGenerating,
    required this.canGenerate,
  });

  final VoidCallback onTap;
  final bool isGenerating;
  final bool canGenerate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: AnimatedOpacity(
        opacity: canGenerate ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: (canGenerate && !isGenerating) ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentSecondary,
            disabledBackgroundColor: AppColors.accentSecondary,
            foregroundColor: Colors.white,
            elevation: canGenerate ? 4 : 0,
            shadowColor: AppColors.accentSecondary.withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isGenerating
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Generating with AI…',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Generate LinkedIn Post',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
