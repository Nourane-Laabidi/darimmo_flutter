import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_client.dart';
import '../../core/theme.dart';
import '../../core/widgets/listing_card.dart';
import '../../models/listing.dart';
import '../home/property_service.dart';

const _types = <String, String>{
  'Tous': '',
  'Appart.': 'apartment',
  'Maison': 'house',
  'Villa': 'villa',
  'Terrain': 'land',
  'Studio': 'studio',
  'Bureau': 'office',
};

class ResultsScreen extends StatefulWidget {
  final String mode;
  final String query;
  const ResultsScreen({super.key, this.mode = 'sale', this.query = ''});
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final _service = PropertyService();
  late final TextEditingController _search;
  late String _mode;
  String _type = '';
  double? _maxPrice;
  int _minBeds = 0;
  late Future<List<Listing>> _future;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    _search = TextEditingController(text: widget.query);
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _load() {
    _future = _service.fetchAll(
      transactionType: _mode,
      type: _type.isEmpty ? null : _type,
      city: _search.text.trim(),
    );
  }

  List<Listing> _apply(List<Listing> all) => all
      .where((l) =>
          (_maxPrice == null || l.price <= _maxPrice!) &&
          l.bedrooms >= _minBeds)
      .toList();

  int get _activeFilters => (_maxPrice != null ? 1 : 0) + (_minBeds > 0 ? 1 : 0);

  Widget _chip(String label, bool selected, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.text)),
        ),
      );

  void _openFilters() {
    double? tmpMax = _maxPrice;
    int tmpBeds = _minBeds;
    final top = _mode == 'rent' ? 5000.0 : 2000000.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filtres',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Text(
                  'Prix maximum : ${tmpMax == null ? 'Illimité' : '${tmpMax!.round()} DT'}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Slider(
                value: tmpMax ?? top,
                min: 0,
                max: top,
                divisions: 40,
                onChanged: (v) => setS(() => tmpMax = v >= top ? null : v),
              ),
              const SizedBox(height: 8),
              const Text('Chambres minimum',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                children: [
                  for (final n in [0, 1, 2, 3, 4])
                    _chip(n == 0 ? 'Tous' : '$n+', tmpBeds == n,
                        () => setS(() => tmpBeds = n)),
                ],
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setS(() {
                      tmpMax = null;
                      tmpBeds = 0;
                    }),
                    child: const Text('Réinitialiser'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _maxPrice = tmpMax;
                        _minBeds = tmpBeds;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Appliquer'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/'),
                ),
                Expanded(
                  child: TextField(
                    controller: _search,
                    decoration: const InputDecoration(
                      hintText: 'Ville, quartier, adresse',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => setState(_load),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  isLabelVisible: _activeFilters > 0,
                  label: Text('$_activeFilters'),
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.tune),
                    onPressed: _openFilters,
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(children: [
                _chip('Acheter', _mode == 'sale', () {
                  setState(() {
                    _mode = 'sale';
                    _maxPrice = null;
                    _load();
                  });
                }),
                _chip('Louer', _mode == 'rent', () {
                  setState(() {
                    _mode = 'rent';
                    _maxPrice = null;
                    _load();
                  });
                }),
              ]),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 10, 8, 0),
                children: [
                  for (final e in _types.entries)
                    _chip(e.key, _type == e.value, () {
                      setState(() {
                        _type = e.value;
                        _load();
                      });
                    }),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Listing>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(apiError(snap.error!),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          OutlinedButton(
                              onPressed: () => setState(_load),
                              child: const Text('Réessayer')),
                        ],
                      ),
                    );
                  }
                  final items = _apply(snap.data ?? []);
                  if (items.isEmpty) {
                    return const Center(
                        child: Text('Aucun bien ne correspond à votre recherche'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return Text(
                            '${items.length} bien${items.length > 1 ? 's' : ''} trouvé${items.length > 1 ? 's' : ''}',
                            style: const TextStyle(color: AppColors.muted));
                      }
                      final l = items[i - 1];
                      return ListingRow(
                        listing: l,
                        onTap: () => context.push('/detail/${l.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}