import 'package:flutter/material.dart';

import '../../domain/entities/listing.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/listing_card.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/search_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = const [
    'All',
    'Mobiliario',
    'Acero',
    'Madera',
  ];

  final List<PromoItem> _promos = [
    PromoItem(
      title: 'Consigue material para tus proyectos',
      subtitle: 'Explora las ofertas disponibles',
      accentColor: const Color(0xFFFE6F3E),
      icon: Icons.devices_other_rounded,
    ),
    PromoItem(
      title: 'Economia Circular',
      subtitle: 'Un paso mas hacia un futuro sostenible',
      accentColor: const Color(0xFF00C48C),
      icon: Icons.shopping_bag_outlined,
    ),
  ];

  late List<Listing> _listings;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _listings = _mockListings;
  }

  void _onCategorySelected(int index) {
    setState(() => _selectedCategory = index);
  }

  void _onToggleSave(String id) {
    setState(() {
      _listings = _listings
          .map((item) =>
              item.id == id ? item.copyWith(isSaved: !item.isSaved) : item)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: 16),
                CategoryFilterBar(
                  categories: _categories,
                  selectedIndex: _selectedCategory,
                  onSelected: _onCategorySelected,
                ),
                const SizedBox(height: 12),
                const SearchInput(),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: PromoCarousel(items: _promos),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cerca de ti',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${_listings.length} items',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = _listings[index];
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: ListingCard(
                            listing: item,
                            animationIndex: index,
                            onToggleSave: () => _onToggleSave(item.id),
                          ),
                        );
                      },
                      childCount: _listings.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.76,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Listing> _mockListings = [
  Listing(
    id: '1',
    title: 'Vigas IPE 200',
    subtitle: '14 unidades (2.5–3.2 m)',
    priceLabel: r'$2000 MXN',
    distanceLabel: '1.2 Km',
    timeAgo: '5 mins ago',
    author: 'Abel del Rio',
    imageUrl:
        'https://tse1.mm.bing.net/th/id/OIP.MJ3c7z5LMr6v4GsgcDU6VAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3',
    isVerified: true,
  ),
  Listing(
    id: '2',
    title: 'Varilla corrugada',
    subtitle: '#4 (sobrante)',
    priceLabel: r'$24 MXN/kg',
    distanceLabel: '1.5 Km',
    timeAgo: '16 mins ago',
    author: 'Daniel Garcia',
    imageUrl:
        'https://images.milanuncios.com/api/v1/ma-ad-media-pro/images/aea4d3a4-1763-469a-bf43-200e61465006?rule=hw396_70',
  ),
  Listing(
    id: '3',
    title: 'Vidrio doble acristalamiento',
    subtitle: '2 años de uso',
    priceLabel: r'$150 MXN',
    distanceLabel: '1 Km',
    timeAgo: '1 hr ago',
    author: 'Yamilet Lopez',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt4fNI4BVeG3vlEDWtwKXEVtlrpekXzdT5Pa0Ytby8mzI0NWl9x8eHOIzqjHzsCzvVkp8&usqp=CAU',
    isVerified: true,
  ),
  Listing(
    id: '4',
    title: 'Escritorio',
    subtitle: '2 años de uso',
    priceLabel: '200 SR',
    distanceLabel: '0.5 Km',
    timeAgo: '2 hr ago',
    author: 'Daniel Garcia',
    imageUrl:
        'https://http2.mlstatic.com/D_NQ_NP_2X_722272-MLM97474256793_112025-T-escritorio-modular-en-l-marca-poliarte-120-x110x60cm.webp',
  ),
  Listing(
    id: '5',
    title: '120 SR',
    subtitle: 'Urban Chair',
    priceLabel: '120 SR',
    distanceLabel: '2 Km',
    timeAgo: '1 hr ago',
    author: 'Julia Ren',
    imageUrl:
        'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=900&q=80',
  ),
  Listing(
    id: '6',
    title: '50 SR',
    subtitle: 'Cycling Helmet',
    priceLabel: '50 SR',
    distanceLabel: '3 Km',
    timeAgo: '3 hr ago',
    author: 'Mark Lope',
    imageUrl:
        'https://images.unsplash.com/photo-1595433707802-8c1727c1a468?auto=format&fit=crop&w=900&q=80',
  ),
];
