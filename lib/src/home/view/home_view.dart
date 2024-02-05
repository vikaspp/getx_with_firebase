import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_with_firebase/src/home/controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CustomSearchDialog();
                },
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: homeController.fetchUsers,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: homeController.userList.value.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => homeController.isLoading.value
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  height: 40,
                                  width: 40,
                                ),
                                title: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  height: 15,
                                  width: double.infinity,
                                ),
                                subtitle: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  height: 15,
                                  width: double.infinity,
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  height: 40,
                                  width: 10,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UpdateItem(
                                      titlecontroller: homeController
                                          .userList[index].title
                                          .toString(),
                                      namecontroller: homeController
                                          .userList[index].name
                                          .toString(),
                                      descontroller: homeController
                                          .userList[index].description
                                          .toString(),
                                    ); // Custom dialog widget
                                  },
                                );
                              },
                              child: ListTile(
                                leading: const FlutterLogo(),
                                title: Text(
                                    '${homeController.userList[index].title}'),
                                subtitle: Text(
                                    '${homeController.userList[index].name}'),
                                trailing: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DeleteUserDialog(
                                          username: homeController
                                              .userList[index].title
                                              .toString(),
                                          // Pass the username you want to delete
                                          onPressed: () async {
                                            await homeController.deleteUser(
                                                userId:
                                                    homeController.list[index]);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.more_vert),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddItemDialog(); // Custom dialog widget
            },
          );
        },
        child: const Text("Add"),
      ),
    );
  }

  Widget shimmerEffect({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}

class UpdateItem extends StatefulWidget {
  final String titlecontroller;
  final String namecontroller;
  final String descontroller;
  const UpdateItem({
    super.key,
    required this.titlecontroller,
    required this.namecontroller,
    required this.descontroller,
  });

  @override
  State<UpdateItem> createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.titlecontroller,
          ),
          Text(
            widget.namecontroller,
          ),
          Text(
            widget.descontroller,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            homeController.addUser();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: homeController.titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: homeController.nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: homeController.descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            homeController.addUser();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class DeleteUserDialog extends StatelessWidget {
  final String username;
  final void Function()? onPressed;

  const DeleteUserDialog({
    super.key,
    required this.username,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete User'),
      content: Text('Are you sure you want to delete user $username?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class CustomSearchDialog extends StatefulWidget {
  const CustomSearchDialog({super.key});

  @override
  State<CustomSearchDialog> createState() => _CustomSearchDialogState();
}

class _CustomSearchDialogState extends State<CustomSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search'),
      content: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Enter your search query',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String searchQuery = _searchController.text;

            homeController.fetchUsersByName(name: _searchController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Search'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
