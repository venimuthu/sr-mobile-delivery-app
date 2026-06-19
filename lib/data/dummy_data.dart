import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/product.dart';

/// The in-memory catalogue used while [AppConfig.useDummyData] is true.
///
/// This is the single file you delete (or stop importing) once the SR
/// Department Store backend serves the real catalogue. The shapes here match
/// [Product.fromJson] / [Category.fromJson] exactly, so the API can return the
/// same structure.
class DummyData {
  DummyData._();

  static const List<Category> categories = [
    Category(id: 'tubs', name: 'Tubs', emoji: '🍨', tint: Color(0xFFFFF0F3)),
    Category(id: 'cones', name: 'Cones & Bars', emoji: '🍦', tint: Color(0xFFFFF6E9)),
    Category(id: 'family', name: 'Family Packs', emoji: '🎉', tint: Color(0xFFEFF4FF)),
    Category(id: 'kulfi', name: 'Kulfi & Indian', emoji: '🍡', tint: Color(0xFFFBEFFF)),
    Category(id: 'frozen', name: 'Frozen Desserts', emoji: '❄️', tint: Color(0xFFEAFBFF)),
    Category(id: 'novelty', name: 'Sundaes', emoji: '🧁', tint: Color(0xFFFFF0EA)),
  ];

  static final List<Product> products = [
    // ---- Tubs ---------------------------------------------------------------
    const Product(
      id: 'p01',
      name: 'Madagascar Vanilla',
      tagline: 'Single-origin bean, real cream',
      description:
          'Slow-churned with whole Madagascar vanilla beans and fresh dairy '
          'cream. The quiet classic that goes with everything.',
      categoryId: 'tubs',
      price: 220,
      mrp: 260,
      unit: '500 ml tub',
      rating: 4.8,
      reviewCount: 1240,
      isFeatured: true,
      emoji: '🍦',
      gradientStart: Color(0xFFFFF7EC),
      gradientEnd: Color(0xFFF6E2BE),
      highlights: ['No artificial flavour', 'Real cream', 'Bean specks'],
    ),
    const Product(
      id: 'p02',
      name: 'Belgian Dark Chocolate',
      tagline: '54% cocoa, deeply fudgy',
      description:
          'Made with imported Belgian couverture for an intense, grown-up '
          'chocolate hit with a soft, scoopable finish.',
      categoryId: 'tubs',
      price: 260,
      mrp: 299,
      unit: '500 ml tub',
      rating: 4.9,
      reviewCount: 2110,
      isFeatured: true,
      emoji: '🍫',
      gradientStart: Color(0xFF6B4A36),
      gradientEnd: Color(0xFF3A2419),
    ),
    const Product(
      id: 'p03',
      name: 'Alphonso Mango',
      tagline: 'Seasonal Ratnagiri pulp',
      description:
          'Sunshine in a tub — real Alphonso mango pulp blended into a smooth, '
          'fruit-forward sorbet-cream.',
      categoryId: 'tubs',
      price: 240,
      unit: '500 ml tub',
      rating: 4.7,
      reviewCount: 880,
      emoji: '🥭',
      gradientStart: Color(0xFFFFE9A8),
      gradientEnd: Color(0xFFFFB347),
      highlights: ['Seasonal', 'Real fruit pulp'],
    ),
    const Product(
      id: 'p04',
      name: 'Strawberry Cheesecake',
      tagline: 'Biscuit swirl, berry ribbon',
      description:
          'Creamy cheesecake base rippled with a tangy strawberry ribbon and '
          'crushed biscuit pieces.',
      categoryId: 'tubs',
      price: 280,
      mrp: 320,
      unit: '500 ml tub',
      rating: 4.6,
      reviewCount: 640,
      emoji: '🍓',
      gradientStart: Color(0xFFFFE3EC),
      gradientEnd: Color(0xFFFF9EB7),
    ),

    // ---- Cones & Bars -------------------------------------------------------
    const Product(
      id: 'p05',
      name: 'Classic Choco Cone',
      tagline: 'Crunchy tip, waffle cone',
      description:
          'Vanilla cream in a crisp waffle cone, dipped in chocolate with a '
          'signature chocolate-filled tip.',
      categoryId: 'cones',
      price: 45,
      unit: 'Pack of 1',
      rating: 4.5,
      reviewCount: 430,
      isFeatured: true,
      emoji: '🍦',
      gradientStart: Color(0xFFFFF1DC),
      gradientEnd: Color(0xFFD9A66B),
    ),
    const Product(
      id: 'p06',
      name: 'Almond Crunch Bar',
      tagline: 'Belgian shell, roasted almonds',
      description:
          'Thick vanilla bar coated in cracking chocolate and roasted almond '
          'pieces. The satisfying snap is the point.',
      categoryId: 'cones',
      price: 60,
      mrp: 75,
      unit: 'Pack of 1',
      rating: 4.7,
      reviewCount: 590,
      emoji: '🍫',
      gradientStart: Color(0xFF8A6A4F),
      gradientEnd: Color(0xFF4E3320),
    ),
    const Product(
      id: 'p07',
      name: 'Cassata Slice',
      tagline: 'Three layers, tutti-frutti',
      description:
          'The old-school favourite — vanilla, strawberry and pista layers with '
          'tutti-frutti and nuts.',
      categoryId: 'cones',
      price: 50,
      unit: 'Pack of 1',
      rating: 4.4,
      reviewCount: 320,
      emoji: '🍰',
      gradientStart: Color(0xFFFCE8F0),
      gradientEnd: Color(0xFFCFE8C9),
    ),

    // ---- Family Packs -------------------------------------------------------
    const Product(
      id: 'p08',
      name: 'Family Neapolitan',
      tagline: 'Vanilla • Strawberry • Chocolate',
      description:
          'The crowd-pleaser. Three classic flavours side by side in a big, '
          'shareable tub for the whole family.',
      categoryId: 'family',
      price: 360,
      mrp: 420,
      unit: '1 L tub',
      rating: 4.6,
      reviewCount: 970,
      isFeatured: true,
      emoji: '🍨',
      gradientStart: Color(0xFFFFE7EE),
      gradientEnd: Color(0xFFC9A2D4),
      highlights: ['Serves 6–8', 'Three flavours'],
    ),
    const Product(
      id: 'p09',
      name: 'Butterscotch Bonanza',
      tagline: 'Caramel praline crunch',
      description:
          'Smooth butterscotch ice cream loaded with crunchy caramelised '
          'praline. A family-pack staple.',
      categoryId: 'family',
      price: 340,
      unit: '1 L tub',
      rating: 4.7,
      reviewCount: 1120,
      emoji: '🍯',
      gradientStart: Color(0xFFFFE9C2),
      gradientEnd: Color(0xFFE0A95C),
    ),
    const Product(
      id: 'p10',
      name: 'Cookies & Cream Party Tub',
      tagline: 'Loaded with cookie chunks',
      description:
          'Vanilla cream packed with dark cookie pieces in a generous party '
          'tub. Disappears fast.',
      categoryId: 'family',
      price: 380,
      mrp: 440,
      unit: '1 L tub',
      rating: 4.8,
      reviewCount: 1450,
      emoji: '🍪',
      gradientStart: Color(0xFFEDEDED),
      gradientEnd: Color(0xFF4A4A4A),
    ),

    // ---- Kulfi & Indian -----------------------------------------------------
    const Product(
      id: 'p11',
      name: 'Malai Kulfi',
      tagline: 'Slow-reduced milk, cardamom',
      description:
          'Dense, traditional kulfi made the long way — reduced milk, a hint of '
          'cardamom and saffron.',
      categoryId: 'kulfi',
      price: 35,
      unit: 'Pack of 1',
      rating: 4.9,
      reviewCount: 760,
      isFeatured: true,
      emoji: '🍡',
      gradientStart: Color(0xFFFFF6E0),
      gradientEnd: Color(0xFFF2D58A),
      highlights: ['Traditional recipe', 'Saffron & cardamom'],
    ),
    const Product(
      id: 'p12',
      name: 'Pista Kulfi',
      tagline: 'Roasted pistachio',
      description:
          'Creamy kulfi studded with roasted pistachios. Earthy, nutty and not '
          'too sweet.',
      categoryId: 'kulfi',
      price: 40,
      unit: 'Pack of 1',
      rating: 4.7,
      reviewCount: 540,
      emoji: '🌰',
      gradientStart: Color(0xFFEAF6D6),
      gradientEnd: Color(0xFFA9C46C),
    ),
    const Product(
      id: 'p13',
      name: 'Falooda Kulfi Combo',
      tagline: 'Kulfi + rose falooda mix',
      description:
          'A ready combo of malai kulfi with rose syrup, basil seeds and '
          'vermicelli to build the perfect falooda at home.',
      categoryId: 'kulfi',
      price: 120,
      mrp: 150,
      unit: 'Serves 2',
      rating: 4.6,
      reviewCount: 280,
      emoji: '🌹',
      gradientStart: Color(0xFFFFE0EC),
      gradientEnd: Color(0xFFE06D9C),
    ),

    // ---- Frozen Desserts ----------------------------------------------------
    const Product(
      id: 'p14',
      name: 'Lemon Sorbet',
      tagline: 'Dairy-free, sharp & clean',
      description:
          'A bright, dairy-free lemon sorbet that resets the palate. Vegan and '
          'refreshing.',
      categoryId: 'frozen',
      price: 200,
      unit: '500 ml tub',
      rating: 4.5,
      reviewCount: 210,
      emoji: '🍋',
      gradientStart: Color(0xFFFFFAD1),
      gradientEnd: Color(0xFFEAD75A),
      highlights: ['Dairy-free', 'Vegan'],
    ),
    const Product(
      id: 'p15',
      name: 'Frozen Yogurt — Blueberry',
      tagline: 'Live cultures, lighter treat',
      description:
          'Tangy frozen yogurt with a real blueberry compote swirl. Lighter '
          'than ice cream, just as good.',
      categoryId: 'frozen',
      price: 230,
      mrp: 270,
      unit: '450 ml tub',
      rating: 4.4,
      reviewCount: 190,
      emoji: '🫐',
      gradientStart: Color(0xFFEAE3FF),
      gradientEnd: Color(0xFF8C7AE6),
    ),
    const Product(
      id: 'p16',
      name: 'Tender Coconut Bar',
      tagline: 'Real coconut bits',
      description:
          'Creamy tender-coconut bar with soft coconut pieces. A South Indian '
          'summer favourite.',
      categoryId: 'frozen',
      price: 40,
      unit: 'Pack of 1',
      rating: 4.6,
      reviewCount: 410,
      emoji: '🥥',
      gradientStart: Color(0xFFF3FBF4),
      gradientEnd: Color(0xFFBFE3C6),
    ),

    // ---- Sundaes & Novelties ------------------------------------------------
    const Product(
      id: 'p17',
      name: 'Hot Fudge Sundae Kit',
      tagline: 'Build-your-own at home',
      description:
          'Vanilla scoops with a sachet of warm-able fudge, nuts and a cherry. '
          'Assemble in two minutes.',
      categoryId: 'novelty',
      price: 160,
      mrp: 190,
      unit: 'Serves 2',
      rating: 4.7,
      reviewCount: 350,
      isFeatured: true,
      emoji: '🍨',
      gradientStart: Color(0xFFFFE8D6),
      gradientEnd: Color(0xFFC9763D),
    ),
    const Product(
      id: 'p18',
      name: 'Choco Lava Mini Cups',
      tagline: 'Molten centre, 4-pack',
      description:
          'Little cups of chocolate ice cream with a molten fudge core. One '
          'each, no sharing required.',
      categoryId: 'novelty',
      price: 140,
      unit: 'Pack of 4',
      rating: 4.8,
      reviewCount: 620,
      emoji: '🌋',
      gradientStart: Color(0xFF7A5240),
      gradientEnd: Color(0xFF3D241A),
    ),
  ];
}
