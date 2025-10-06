import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../utils/app_theme.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  int _selectedIndex = 1;

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        // Already on contacts
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/alerts');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Emergency Contacts'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddContactDialog(context, appState),
              ),
            ],
          ),
          body: appState.emergencyContacts.isEmpty
              ? _buildEmptyState(context)
              : _buildContactsList(context, appState),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onBottomNavTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.contacts_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'No Emergency Contacts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Add trusted contacts who will be notified during emergencies.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              onPressed: () => _showAddContactDialog(
                context, 
                Provider.of<AppStateProvider>(context, listen: false),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList(BuildContext context, AppStateProvider appState) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appState.emergencyContacts.length,
      itemBuilder: (context, index) {
        final contact = appState.emergencyContacts[index];
        return _buildContactCard(context, appState, contact);
      },
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    AppStateProvider appState,
    EmergencyContact contact,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: contact.isPrimary 
                  ? AppTheme.primaryBlue 
                  : Colors.grey.shade300,
              child: Text(
                contact.name.isNotEmpty 
                    ? contact.name[0].toUpperCase() 
                    : '?',
                style: TextStyle(
                  color: contact.isPrimary ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Contact info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (contact.isPrimary)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'PRIMARY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    contact.phone,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  Text(
                    contact.relationship,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditContactDialog(context, appState, contact);
                    break;
                  case 'primary':
                    appState.setPrimaryContact(contact.id);
                    break;
                  case 'delete':
                    _showDeleteContactDialog(context, appState, contact);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                if (!contact.isPrimary)
                  const PopupMenuItem(
                    value: 'primary',
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 20),
                        SizedBox(width: 8),
                        Text('Set as Primary'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: AppTheme.emergencyRed),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: AppTheme.emergencyRed)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context, AppStateProvider appState) {
    _showContactDialog(context, appState, null);
  }

  void _showEditContactDialog(
    BuildContext context,
    AppStateProvider appState,
    EmergencyContact contact,
  ) {
    _showContactDialog(context, appState, contact);
  }

  void _showContactDialog(
    BuildContext context,
    AppStateProvider appState,
    EmergencyContact? existingContact,
  ) {
    final nameController = TextEditingController(
      text: existingContact?.name ?? '',
    );
    final phoneController = TextEditingController(
      text: existingContact?.phone ?? '',
    );
    final relationshipController = TextEditingController(
      text: existingContact?.relationship ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingContact == null ? 'Add Contact' : 'Edit Contact'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  prefixIcon: Icon(Icons.family_restroom),
                  hintText: 'e.g., Family, Friend, Colleague',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the relationship';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final contact = EmergencyContact(
                  id: existingContact?.id ?? 
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  relationship: relationshipController.text.trim(),
                  isPrimary: existingContact?.isPrimary ?? false,
                );
                
                if (existingContact == null) {
                  appState.addEmergencyContact(contact);
                } else {
                  appState.updateEmergencyContact(existingContact.id, contact);
                }
                
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: Text(existingContact == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteContactDialog(
    BuildContext context,
    AppStateProvider appState,
    EmergencyContact contact,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text(
          'Are you sure you want to delete ${contact.name} from your emergency contacts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.removeEmergencyContact(contact.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emergencyRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}