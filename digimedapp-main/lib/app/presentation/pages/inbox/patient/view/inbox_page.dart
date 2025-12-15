import 'package:digimed/app/domain/models/notification_model/notification_model.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/notification_icons_icons.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/inbox/patient/controller/inbox_controller.dart';
import 'package:digimed/app/presentation/pages/inbox/patient/controller/state/inbox_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (_) => InboxController(
              InboxState(
                  notificationState: NotificationState.loaded(
                      sessionController.state!.notifications)),
              accountRepository: Repositories.account,
              sessionController: context.read(),
            ),
        child: MyScaffold(body: Builder(builder: (context) {
          final controller = Provider.of<InboxController>(
            context,
            listen: true,
          );
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.beginGradient, AppColors.endGradient]),
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Custom App Bar (similar structure) =====
                Padding(
                  padding: EdgeInsets.only(
                      left: 24, top: size.height * 0.05, right: 25),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Notificaciones",
                        style: AppTextStyle.bannerWhiteContentTextStyle,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                    child: controller.state.notificationState.when(loading: () {
                  return const Center(child: CircularProgressIndicator());
                }, failed: (error) {
                  return Center(child: Text('Error: $error'));
                }, loaded: (data) {
                  if (data.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => controller.onRefresh(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: _buildEmptyState(),
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => controller.onRefresh(),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final notification = data[index];
                        return NotificationCard(notification: notification);
                      },
                    ),
                  );
                })),
              ],
            ),
          );
        })));
  }

  Widget NotificationCard({required NotificationModel notification}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: NotificationTile(notification: notification),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No tiene notificaciones disponibles'),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final NotificationModel notification;

  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() async {
    if (!widget.notification.read) {
      final controller = Provider.of<InboxController>(
        context,
        listen: false,
      );
      controller.markAsRead(widget.notification.id);
    }
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icono de notificación
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: widget.notification.read
                        ? Assets.svgs.noReadInbox.svg()
                        : Assets.svgs.readInbox.svg(),
                  ),
                  const SizedBox(width: 12),

                  // Título de la notificación
                  Expanded(
                    child: Text(
                      widget.notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        color: widget.notification.read
                            ? Colors.grey[600]
                            : Colors.black87,
                      ),
                    ),
                  ),

                  // Flecha de expansión
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0xFF2196F3),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido expandible
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 52, // Alineado con el texto del título
                right: 16,
                bottom: 16,
              ),
              child: Text(
                widget.notification.body,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
