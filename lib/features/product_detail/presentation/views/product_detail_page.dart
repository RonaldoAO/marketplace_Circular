import 'package:flutter/material.dart';

import '../../../catalog/domain/entities/listing.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            stretch: true,
            expandedHeight: 340,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              _CircleBtn(
                icon: Icons.ios_share_rounded,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _CircleBtn(
                icon: listing.isSaved
                    ? Icons.bookmark
                    : Icons.bookmark_border_rounded,
                onTap: () {},
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    listing.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '1/6',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SummaryHeader(listing: listing),
          ),
        ],
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This lightly used ${listing.subtitle} is available for purchase, as I am moving next week.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Condition: Good',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Precio',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          listing.priceLabel,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFE6F3E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Hacer una oferta',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryHeader extends SliverPersistentHeaderDelegate {
  _SummaryHeader({required this.listing});

  final Listing listing;

  @override
  double get minExtent => 200;

  @override
  double get maxExtent => 220;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _Avatar(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Laila Gamil',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text('4.5 (4)'),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              _RoundIcon(
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  listing.subtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 8),
              const _CountdownBadge(deadlineHoursFromNow: 72),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Chip(label: 'Barter online'),
              const SizedBox(width: 8),
              _Chip(label: 'Final Price'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SummaryHeader oldDelegate) {
    return oldDelegate.listing != listing;
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
          ),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.grey[700]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFFE6F3E), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFE6F3E),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBadge extends StatefulWidget {
  const _CountdownBadge({required this.deadlineHoursFromNow});

  final int deadlineHoursFromNow;

  @override
  State<_CountdownBadge> createState() => _CountdownBadgeState();
}

class _CountdownBadgeState extends State<_CountdownBadge>
    with SingleTickerProviderStateMixin {
  late DateTime _deadline;
  late Duration _remaining;
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    _deadline = DateTime.now().add(Duration(hours: widget.deadlineHoursFromNow));
    _remaining = _deadline.difference(DateTime.now());
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..addListener(() {
        _onTick(_ticker.lastElapsedDuration ?? Duration.zero);
      });
    _ticker.repeat();
  }

  void _onTick(Duration elapsed) {
    final rem = _deadline.difference(DateTime.now());
    if (rem <= Duration.zero) {
      setState(() {
        _remaining = Duration.zero;
      });
      _ticker.stop();
    } else {
      setState(() {
        _remaining = rem;
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    if (d <= Duration.zero) return 'Finalizado';

    if (d.inDays >= 1) {
      final days = d.inDays;
      final hours = d.inHours % 24;
      return '${days}d ${hours}h';
    }
    if (d.inHours >= 1) {
      final hours = d.inHours;
      final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
      return '${hours}h ${minutes}m';
    }
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final text = _format(_remaining);
    final isCritical = _remaining.inHours < 1;
    final bg = isCritical ? Colors.red.shade50 : Colors.grey.shade200;
    final fg = isCritical ? Colors.red : Colors.grey[800];

    return Row(
      children: [
        Text(
          'Se cierra en:',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
