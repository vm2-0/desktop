import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem(this.title, this.description, this.imageName, this.onTap);
  final String title;
  final String description;
  final String imageName;
  final VoidCallback onTap;
}

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({super.key, required this.item});
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return InkWell(
      onTap: item.onTap,
      child: CardWidget(
        variant: CardVariant.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.asset(
                  item.imageName,
                  width: mediaQuery.size.width * 0.2,
                  height: mediaQuery.size.height * 0.2,
                  color: ClonesColors.tertiary,
                ),
                Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    item.imageName,
                    width: mediaQuery.size.width * 0.2,
                    height: mediaQuery.size.height * 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Column(
              children: [
                Text(
                  item.title.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: ClonesColors.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.description,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
