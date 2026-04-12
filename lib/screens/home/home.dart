import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/components/home_components/side_bar.dart';
import 'package:iu_auditor_admin/screens/home/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final width    = MediaQuery.of(context).size.width;
    final isTablet = width >= 768 && width < 1200;
    final isMobile = width < 768;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              child: SideBar(
                listItems: controller.menuItems,
                isCollapsed: false,
              ),
            )
          : null,

      body: Row(
        children: [
          if (!isMobile)
            SideBar(
              listItems: controller.menuItems,
              isCollapsed: isTablet,
            ),

          Expanded(
            child: Obx(() => _LazyIndexedStack(
              index: controller.selectedIndex.value,
              children: controller.pages,
            )),
          ),
        ],
      ),
    );
  }
}

/// A drop-in replacement for [IndexedStack] that builds each child only once —
/// the first time that index is selected. After the first visit the child stays
/// mounted (so its controller / scroll position is preserved), but it is never
/// built before the user actually taps its tab.
///
/// This means every page controller's [onInit] (and therefore every API call)
/// fires lazily, only when the user first navigates to that page.
class _LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const _LazyIndexedStack({
    required this.index,
    required this.children,
  });

  @override
  State<_LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<_LazyIndexedStack> {
  /// Tracks which pages have been visited at least once.
  /// Only visited pages are built; the rest are replaced with SizedBox.shrink().
  late List<bool> _activated;

  @override
  void initState() {
    super.initState();
    // Initially only the first selected page is active
    _activated = List.filled(widget.children.length, false);
    _activated[widget.index] = true;
  }

  @override
  void didUpdateWidget(_LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Activate the newly selected page on first visit
    if (!_activated[widget.index]) {
      setState(() => _activated[widget.index] = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: List.generate(widget.children.length, (i) {
        // Show the real widget only if this page has been visited
        return _activated[i] ? widget.children[i] : const SizedBox.shrink();
      }),
    );
  }
}