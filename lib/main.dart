import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DonationPortalApp());
}

class Donation {
  const Donation({
    required this.donorName,
    required this.amount,
    required this.date,
    required this.purpose,
  });

  final String donorName;
  final int amount;
  final DateTime date;
  final String purpose;
}

class FundCategory {
  const FundCategory({
    required this.name,
    required this.amount,
    required this.icon,
  });

  final String name;
  final int amount;
  final IconData icon;
}

class NgoActivity {
  const NgoActivity({
    required this.title,
    required this.description,
    required this.status,
  });

  final String title;
  final String description;
  final String status;
}

const fundCategories = <FundCategory>[
  FundCategory(
    name: 'Food Distribution',
    amount: 12000,
    icon: Icons.restaurant,
  ),
  FundCategory(name: 'Education Support', amount: 8000, icon: Icons.school),
  FundCategory(
    name: 'Medical Assistance',
    amount: 6000,
    icon: Icons.medical_services,
  ),
  FundCategory(
    name: 'Administrative Expenses',
    amount: 4000,
    icon: Icons.business_center,
  ),
];

const ngoActivities = <NgoActivity>[
  NgoActivity(
    title: 'Food Distribution for Poor Families',
    description:
        'Weekly grocery kits are shared with families in nearby communities.',
    status: 'Completed',
  ),
  NgoActivity(
    title: 'Educational Support for Students',
    description:
        'Learning materials and after-school study sessions help local students.',
    status: 'Ongoing',
  ),
  NgoActivity(
    title: 'Medical Camps',
    description:
        'Volunteer health professionals provide basic check-ups and guidance.',
    status: 'Completed',
  ),
  NgoActivity(
    title: 'Clothing Distribution',
    description:
        'Clean, donated clothing is sorted and shared with people who need it.',
    status: 'Ongoing',
  ),
];

class DonationPortalApp extends StatelessWidget {
  const DonationPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16845B);
    return MaterialApp(
      title: 'NGO Donation Transparency Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
          secondary: const Color(0xFF2674C8),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: false,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE7EEEA)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F9F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE6E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE6E0)),
          ),
        ),
      ),
      home: const PortalHomePage(),
    );
  }
}

class PortalHomePage extends StatefulWidget {
  const PortalHomePage({super.key});

  @override
  State<PortalHomePage> createState() => _PortalHomePageState();
}

class _PortalHomePageState extends State<PortalHomePage> {
  int _selectedIndex = 0;
  final List<Donation> _donations = [
    Donation(
      donorName: 'Aarav Sharma',
      amount: 12000,
      date: DateTime(2026, 10, 5),
      purpose: 'Food kits for families',
    ),
    Donation(
      donorName: 'Meera Patel',
      amount: 10000,
      date: DateTime(2026, 10, 8),
      purpose: 'Student learning materials',
    ),
    Donation(
      donorName: 'Rohan Verma',
      amount: 8000,
      date: DateTime(2026, 10, 12),
      purpose: 'Community medical camp',
    ),
    Donation(
      donorName: 'Ananya Rao',
      amount: 12000,
      date: DateTime(2026, 10, 18),
      purpose: 'General community support',
    ),
    Donation(
      donorName: 'Kabir Singh',
      amount: 8000,
      date: DateTime(2026, 10, 23),
      purpose: 'Clothing distribution',
    ),
  ];

  int get _totalDonations =>
      _donations.fold(0, (total, donation) => total + donation.amount);

  int get _totalUtilized =>
      fundCategories.fold(0, (total, category) => total + category.amount);

  int get _remainingFunds => _totalDonations - _totalUtilized;

  Future<void> _addDonation() async {
    final donation = await showDialog<Donation>(
      context: context,
      builder: (context) => const AddDonationDialog(),
    );

    if (donation == null || !mounted) {
      return;
    }

    setState(() {
      _donations.insert(0, donation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Donation added successfully.')),
    );
  }

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Donation Transparency',
      'Donations',
      'Fund Utilization',
      'NGO Activities',
      'About Us',
    ];

    final pages = [
      DashboardPage(
        totalDonations: _totalDonations,
        totalUtilized: _totalUtilized,
        remainingFunds: _remainingFunds,
        onNavigate: _navigateTo,
      ),
      DonationsPage(donations: _donations, onAddDonation: _addDonation),
      const FundUtilizationPage(),
      const ActivitiesPage(),
      const AboutPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedIndex],
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _navigateTo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: 'Donations',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: 'Funds',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.totalDonations,
    required this.totalUtilized,
    required this.remainingFunds,
    required this.onNavigate,
    super.key,
  });

  final int totalDonations;
  final int totalUtilized;
  final int remainingFunds;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final utilization =
        totalDonations == 0
            ? 0.0
            : (totalUtilized / totalDonations).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFFE4F5EC), Color(0xFFEAF3FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NGO Donation\nTransparency Portal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome! See how community support is collected and used.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF53645B),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.volunteer_activism,
                  size: 30,
                  color: Color(0xFF16845B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeading(
          title: 'Donation overview',
          subtitle: 'A clear snapshot of the sample fund balance.',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 520 ? 3 : 2;
            final cardWidth =
                (constraints.maxWidth - (columns - 1) * 12) / columns;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: SummaryCard(
                    label: 'Total Donations',
                    amount: totalDonations,
                    icon: Icons.savings_outlined,
                    color: const Color(0xFF16845B),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: SummaryCard(
                    label: 'Amount Utilized',
                    amount: totalUtilized,
                    icon: Icons.account_balance_wallet_outlined,
                    color: const Color(0xFF2674C8),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: SummaryCard(
                    label: 'Remaining Funds',
                    amount: remainingFunds,
                    icon: Icons.paid_outlined,
                    color: const Color(0xFFB36B16),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Funds utilized',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      '${(utilization * 100).round()}%',
                      style: const TextStyle(
                        color: Color(0xFF16845B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: utilization,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE7EEEA),
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  '${formatRupees(totalUtilized)} utilized out of '
                  '${formatRupees(totalDonations)} received',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF65736B),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeading(
          title: 'Explore the portal',
          subtitle: 'Choose a section to learn more.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: () => onNavigate(1),
              icon: const Icon(Icons.volunteer_activism_outlined),
              label: const Text('Donations'),
            ),
            OutlinedButton.icon(
              onPressed: () => onNavigate(2),
              icon: const Icon(Icons.pie_chart_outline),
              label: const Text('Fund utilization'),
            ),
            OutlinedButton.icon(
              onPressed: () => onNavigate(3),
              icon: const Icon(Icons.groups_outlined),
              label: const Text('NGO activities'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const DemoDataNotice(),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    super.key,
  });

  final String label;
  final int amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF65736B)),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formatRupees(amount),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonationsPage extends StatelessWidget {
  const DonationsPage({
    required this.donations,
    required this.onAddDonation,
    super.key,
  });

  final List<Donation> donations;
  final VoidCallback onAddDonation;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const Expanded(
              child: SectionHeading(
                title: 'Donation records',
                subtitle: 'Sample entries stored on this device only.',
              ),
            ),
            FilledButton.icon(
              key: const ValueKey('addDonationButton'),
              onPressed: onAddDonation,
              icon: const Icon(Icons.add),
              label: const Text('Add Donation'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (donations.isEmpty)
          const EmptyState(
            icon: Icons.volunteer_activism_outlined,
            title: 'No donations yet',
            message: 'Add a donation to see it listed here.',
          )
        else
          for (final donation in donations) DonationCard(donation: donation),
        const SizedBox(height: 8),
        const DemoDataNotice(),
      ],
    );
  }
}

class DonationCard extends StatelessWidget {
  const DonationCard({required this.donation, super.key});

  final Donation donation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE5F4EC),
              child: Icon(
                Icons.volunteer_activism_outlined,
                color: Color(0xFF16845B),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.donorName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    donation.purpose,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDate(donation.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF65736B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatRupees(donation.amount),
              style: const TextStyle(
                color: Color(0xFF16845B),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddDonationDialog extends StatefulWidget {
  const AddDonationDialog({super.key});

  @override
  State<AddDonationDialog> createState() => _AddDonationDialogState();
}

class _AddDonationDialogState extends State<AddDonationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveDonation() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    Navigator.of(context).pop(
      Donation(
        donorName: _nameController.text.trim(),
        amount: int.parse(_amountController.text.trim()),
        date: _selectedDate,
        purpose: _purposeController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a donation'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const ValueKey('donorNameField'),
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Donor name'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Enter the donor name'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('donationAmountField'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixText: '₹ ',
                ),
                validator: (value) {
                  final amount = int.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Enter an amount greater than zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const ValueKey('donationDateButton'),
                onPressed: _chooseDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text('Date: ${formatDate(_selectedDate)}'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('donationPurposeField'),
                controller: _purposeController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Purpose'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Enter the donation purpose'
                            : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const ValueKey('saveDonationButton'),
          onPressed: _saveDonation,
          child: const Text('Save donation'),
        ),
      ],
    );
  }
}

class FundUtilizationPage extends StatelessWidget {
  const FundUtilizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final total = fundCategories.fold(
      0,
      (sum, category) => sum + category.amount,
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeading(
          title: 'Where funds go',
          subtitle: 'A breakdown of the sample ₹30,000 utilized.',
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFEAF3FC),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF2674C8),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Total amount utilized',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  formatRupees(total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2674C8),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        for (final category in fundCategories)
          SpendingCard(category: category, total: total),
        const SizedBox(height: 8),
        const DemoDataNotice(),
      ],
    );
  }
}

class SpendingCard extends StatelessWidget {
  const SpendingCard({required this.category, required this.total, super.key});

  final FundCategory category;
  final int total;

  @override
  Widget build(BuildContext context) {
    final share = total == 0 ? 0.0 : category.amount / total;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEAF3FC),
                  child: Icon(category.icon, color: const Color(0xFF2674C8)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  formatRupees(category.amount),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: share,
                minHeight: 8,
                backgroundColor: const Color(0xFFE7EEEA),
                color: const Color(0xFF2674C8),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(share * 100).round()}% of utilized funds',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF65736B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeading(
          title: 'Community activities',
          subtitle: 'Examples of the work supported by the NGO.',
        ),
        const SizedBox(height: 14),
        for (final activity in ngoActivities)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE5F4EC),
                    child: Icon(
                      Icons.volunteer_activism_outlined,
                      color: Color(0xFF16845B),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activity.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF53645B),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        StatusBadge(status: activity.status),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const DemoDataNotice(),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final completed = status == 'Completed';
    final color = completed ? const Color(0xFF16845B) : const Color(0xFF2674C8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F4EC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.visibility_outlined,
                color: Color(0xFF16845B),
                size: 30,
              ),
              SizedBox(height: 12),
              Text(
                'Giving with clarity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8),
              Text(
                'This portal is a student project that demonstrates how an NGO '
                'can present donations, spending categories, and community work '
                'in one easy-to-understand place.',
                style: TextStyle(height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why transparency matters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Clear summaries help donors understand how contributions '
                  'are recorded and what kinds of work they support. In this '
                  'demo, all records are sample data and are not verified '
                  'real-world transactions.',
                  style: TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contact (sample details)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                const ContactRow(
                  icon: Icons.email_outlined,
                  text: 'hello@example.org',
                ),
                const SizedBox(height: 10),
                const ContactRow(
                  icon: Icons.phone_outlined,
                  text: '+91 98765 43210',
                ),
                const SizedBox(height: 10),
                const ContactRow(
                  icon: Icons.location_on_outlined,
                  text: 'Sample address, India',
                ),
                const SizedBox(height: 12),
                Text(
                  'These contact details are fictional examples for the project.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF65736B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ContactRow extends StatelessWidget {
  const ContactRow({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF16845B)),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF65736B)),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: Column(
        children: [
          Icon(icon, size: 44, color: const Color(0xFF16845B)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class DemoDataNotice extends StatelessWidget {
  const DemoDataNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 19, color: Color(0xFF9A6415)),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Demo only: sample records are illustrative, not verified '
              'transactions. Changes are kept in memory and reset when the '
              'app restarts.',
              style: TextStyle(
                color: Color(0xFF725221),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String formatRupees(int amount) {
  final digits = amount.toString();
  if (digits.length <= 3) {
    return '₹$digits';
  }

  final prefixLength = digits.length - 3;
  var firstGroupLength = prefixLength % 2;
  if (firstGroupLength == 0) {
    firstGroupLength = 2;
  }

  final grouped = StringBuffer(digits.substring(0, firstGroupLength));
  for (var index = firstGroupLength; index < prefixLength; index += 2) {
    grouped
      ..write(',')
      ..write(digits.substring(index, index + 2));
  }
  grouped
    ..write(',')
    ..write(digits.substring(prefixLength));
  return '₹$grouped';
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
