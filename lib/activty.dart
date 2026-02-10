import 'package:flutter/material.dart';
import 'photo.dart';



// Data Model for Activity
class Activity {
  final String title;
  final String category;
  final String? duration;
  final String imageUrl;
  final String buttonText;
  final IconData? buttonIcon;

  Activity({
    required this.title,
    required this.category,
    this.duration,
    required this.imageUrl,
    required this.buttonText,
    this.buttonIcon,
  });
}

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  // Original Data
  final List<Activity> _allActivities = [
    Activity(
      title: 'Mall of Arabia',
      category: 'Shopping Malls',
      imageUrl: 'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?q=80&w=1000&auto=format&fit=crop',
      buttonText: 'View on map',
      buttonIcon: Icons.location_on,
      
    ),
    Activity(
      title: 'Jeddah Beauty show',
      category: 'Event',
      duration: 'Duration More3 than 3 hours',
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=1000&auto=format&fit=crop',
      buttonText: 'View Details',
    ),
    
  ];

  // State for filtering
  List<Activity> _filteredActivities = [];
  String _searchQuery = '';
  String _selectedDuration = ''; // Empty means no filter

  @override
  void initState() {
    super.initState();
    _filteredActivities = _allActivities;
  }

  void _applyFilters() {
    setState(() {
      _filteredActivities = _allActivities.where((activity) {
        final matchesSearch = activity.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            activity.category.toLowerCase().contains(_searchQuery.toLowerCase());
        
        final matchesDuration = _selectedDuration.isEmpty || 
            (activity.duration != null && activity.duration == _selectedDuration);
            
        return matchesSearch && matchesDuration;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _showFilters() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FiltersBottomSheet(initialSelection: _selectedDuration),
    );

    if (result != null) {
      setState(() {
        _selectedDuration = result == 'CLEAR' ? '' : result;
        _applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF79926C)),
           onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar and Filter Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF79926C)),
                    ),
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: const InputDecoration(
                        hintText: 'Discover activates',
                        hintStyle: TextStyle(color: Color.fromARGB(255, 156, 175, 175), fontSize: 14),
                        prefixIcon: Icon(Icons.search,color: Color(0xFF79926C)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _showFilters,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC49A83),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.tune, color: Colors.white),
                        if (_selectedDuration.isNotEmpty)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
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
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Activities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                     color: Color(0xFF515F49),
                  ),
                ),
                if (_selectedDuration.isNotEmpty)
                  Text(
                    'Filter: $_selectedDuration',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFC49A83), fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Activities List
          Expanded(
            child: _filteredActivities.isEmpty
                ? const Center(child: Text('No activities found matching your criteria.'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredActivities.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final activity = _filteredActivities[index];
                      return ActivityCard(
                        title: activity.title,
                        category: activity.category,
                        duration: activity.duration,
                        imageUrl: activity.imageUrl,
                        buttonText: activity.buttonText,
                        buttonIcon: activity.buttonIcon,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String category;
  final String? duration;
  final String imageUrl;
  final String buttonText;
  final IconData? buttonIcon;

  const ActivityCard({
    super.key,
    required this.title,
    required this.category,
    this.duration,
    required this.imageUrl,
    required this.buttonText,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         color: Color(0xFF79926C),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image sitting inside the green box
          Padding(
            padding: const EdgeInsets.all(4.0), // Padding to show green edges around image
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Image's own rounded corners
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 160, // Fixed height for the image part
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
          // Content area (the part of the green box that extends below the image)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title and Category
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            category,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      if (duration != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              duration!,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Action Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC49A83), // Solid button color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (buttonIcon != null) ...[
                        Icon(buttonIcon, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        buttonText,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', false),
          _buildNavItem(Icons.near_me_outlined, 'Nearby', true),
          _buildCenterNavItem(context),
          _buildNavItem(Icons.airplanemode_active_outlined, 'My Trip', false),
          _buildNavItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? const Color(0xFFC49A83) : const Color(0xFF9CA3AF)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFFC49A83) : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterNavItem(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UploadPhotoScreen()),
      );
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6B8E7B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add_a_photo_outlined,
              color: Colors.white, size: 24),
        ),
        const SizedBox(height: 4),
        const Text(
          'Scan a landmark',
          style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
        ),
      ],
    ),
  );
}

}

class FiltersBottomSheet extends StatefulWidget {
  final String initialSelection;
  const FiltersBottomSheet({super.key, required this.initialSelection});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  late String _tempSelection;

  @override
  void initState() {
    super.initState();
    _tempSelection = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF79926C)),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Suggested duration',
              style: TextStyle(fontSize:18,fontWeight: FontWeight.w600, color: Color(0xFF79926C)),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildFilterChip('<1 hour'),
                _buildFilterChip('1-2 hours'),
                _buildFilterChip('2-3 hours'),
                _buildFilterChip('More than 3 hours'),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'CLEAR'),
                  child: const Text(
                    'Clear filters',
                    style: TextStyle(color: Color(0xFF779926C)
                     ,decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _tempSelection),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC49A83),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Show results'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _tempSelection == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tempSelection = isSelected ? '' : label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F4F6) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6B8E7B) : const Color(0xFFD1D5DB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
           color: Color(0xFF79926C),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
