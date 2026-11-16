import 'package:flutter/material.dart';

/// The three actions shown on a course card.
class CourseActionsMenu extends StatefulWidget {
  const CourseActionsMenu({
    super.key,
    required this.onDownload,
    required this.onHide,
    required this.onStar,
    this.starred = false,
    this.hidden = false,
    this.downloadEnabled = true,
    this.downloaded = false,
    this.mutationEnabled = true,
  });

  final VoidCallback onDownload;
  final VoidCallback onHide;
  final VoidCallback onStar;
  final bool starred, hidden, downloadEnabled, downloaded, mutationEnabled;

  @override
  State<CourseActionsMenu> createState() => _CourseActionsMenuState();
}

class _CourseActionsMenuState extends State<CourseActionsMenu> {
  final _anchor = GlobalKey();

  Future<void> _open() async {
    final box = _anchor.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final origin = box.localToGlobal(Offset.zero);
    final size = MediaQuery.sizeOf(context);
    final right = (size.width - origin.dx - box.size.width).clamp(
      8.0,
      (size.width - 258).clamp(8.0, double.infinity),
    );
    final below = size.height - origin.dy - box.size.height > 180;
    final top = below ? origin.dy + box.size.height + 4 : origin.dy - 158;
    final ukrainian = Localizations.localeOf(context).languageCode == 'uk';
    final choice = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black12,
      pageBuilder: (dialogContext, _, _) => Stack(
        children: [
          Positioned(
            right: right,
            top: top.clamp(
              MediaQuery.paddingOf(context).top + 8,
              size.height - 162,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (below)
                  const Padding(
                    padding: EdgeInsets.only(right: 26),
                    child: _MenuPointer(),
                  ),
                Material(
                  color: Colors.white,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _row(
                          dialogContext,
                          Icons.cloud_download,
                          widget.downloaded
                              ? (ukrainian
                                    ? 'Оновити завантаження'
                                    : 'Refresh download')
                              : (ukrainian
                                    ? 'Завантажити курс'
                                    : 'Download course'),
                          0,
                          enabled: widget.downloadEnabled,
                        ),
                        _row(
                          dialogContext,
                          Icons.visibility,
                          widget.hidden
                              ? (ukrainian
                                    ? 'Повернути до огляду'
                                    : 'Show in view')
                              : (ukrainian
                                    ? 'Прибрати з огляду'
                                    : 'Remove from view'),
                          1,
                          enabled: widget.mutationEnabled,
                        ),
                        _row(
                          dialogContext,
                          Icons.star,
                          widget.starred
                              ? (ukrainian
                                    ? 'Прибрати зірку'
                                    : 'Unstar this course')
                              : (ukrainian
                                    ? 'Позначити курс зіркою'
                                    : 'Star this course'),
                          2,
                          enabled: widget.mutationEnabled,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!below)
                  const Padding(
                    padding: EdgeInsets.only(right: 26),
                    child: RotatedBox(quarterTurns: 2, child: _MenuPointer()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!mounted) return;
    switch (choice) {
      case 0:
        widget.onDownload();
      case 1:
        widget.onHide();
      case 2:
        widget.onStar();
    }
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String title,
    int value, {
    bool enabled = true,
  }) => InkWell(
    onTap: enabled ? () => Navigator.of(context).pop(value) : null,
    child: SizedBox(
      height: 48,
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            icon,
            size: 25,
            color: enabled ? const Color(0xff4a5359) : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: enabled ? const Color(0xff292929) : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => IconButton(
    key: _anchor,
    tooltip: 'Course actions',
    onPressed: _open,
    icon: const Icon(Icons.more_vert),
  );
}

class _MenuPointer extends StatelessWidget {
  const _MenuPointer();
  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(20, 10),
    painter: _PointerPainter(),
  );
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
