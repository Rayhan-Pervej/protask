import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/user_list/user_card.dart';
import 'package:protask/cubit/user_list/userlist_cubit.dart';
import 'package:protask/screens/users/userstasks.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: MyColor.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          FluentIcons.people_community_48_filled,
                          color: Colors.blue.shade600,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Team Members',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            BlocBuilder<UserlistCubit, UserlistState>(
                              builder: (context, state) {
                                int userCount = 0;
                                if (state is UserlistLoaded) {
                                  userCount = state.users.length;
                                }
                                return Text(
                                  '$userCount team members',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Enhanced Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search team members...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.grey.shade500,
                            size: 18,
                          ),
                        ),
                        suffixIcon:
                            searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.xmark,
                                    color: Colors.grey.shade500,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    context.read<UserlistCubit>().searchUsers(
                                      '',
                                    );
                                    setState(() {});
                                  },
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      onChanged: (query) {
                        context.read<UserlistCubit>().searchUsers(query);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: BlocBuilder<UserlistCubit, UserlistState>(
                builder: (context, state) {
                  if (state is UserlistLoading) {
                    return _buildLoadingState();
                  } else if (state is UserlistLoaded) {
                    final users = state.users;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<UserlistCubit>().fetchUsers();
                      },
                      color: Colors.blue.shade600,
                      child:
                          users.isEmpty
                              ? _buildNoUsersFound()
                              : _buildUsersList(users),
                    );
                  } else if (state is UserlistError) {
                    return _buildErrorState(context, state.message);
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading team members...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List users) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: UserCard(
              avatarUrl:
                  users[index]['photo'] ?? "https://via.placeholder.com/150",
              name: users[index]['name'] ?? 'Unknown User',
              position: users[index]['position'] ?? 'Role unassigned',
              email: users[index]['email'] ?? 'No Email',
              onTap: () {
                int userId = users[index]['id'];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => UsersTasks(
                          userId: userId,
                          userName: users[index]['name'],
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoUsersFound() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.userSlash,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Team Members Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchController.text.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'No team members available at the moment',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (searchController.text.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () {
                  searchController.clear();
                  context.read<UserlistCubit>().searchUsers('');
                  setState(() {});
                },
                icon: const Icon(FontAwesomeIcons.arrowRotateLeft, size: 16),
                label: const Text('Clear Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserlistCubit>().fetchUsers();
      },
      color: Colors.blue.shade600,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 48,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<UserlistCubit>().fetchUsers();
                },
                icon: const Icon(FontAwesomeIcons.arrowRotateLeft, size: 16),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
