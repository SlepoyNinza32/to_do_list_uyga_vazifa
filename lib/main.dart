import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list_uyga_vazifa/to_do_model.dart';

late Box<ToDoModel> box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoModelAdapter());
  box = await Hive.openBox<ToDoModel>('to_do');
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController titleController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  bool isChanged = false;
  bool isEditing = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: isChanged == false
            ? const Text('To Do List')
            : Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(
                        () {
                          isChanged = false;
                          box.putAt(
                            index,
                            ToDoModel(
                              title: box.getAt(index)!.title,
                              describe: box.getAt(index)!.describe,
                              isSelected: false,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                      setState(
                        () {
                          isChanged = false;
                          box.deleteAt(index);
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(
                        () {
                          titleController.text = box.getAt(index)!.title;
                          describeController.text = box.getAt(index)!.describe;
                          isChanged = false;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Edit Task'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titleController,
                                    decoration: const InputDecoration(
                                      labelText: 'change task',
                                      border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(width: 3),
                                      ),
                                      focusColor: Colors.greenAccent,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.greenAccent),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    controller: describeController,
                                    decoration: const InputDecoration(
                                      labelText: 'change describe',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 3),
                                      ),
                                      focusColor: Colors.greenAccent,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.greenAccent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                MaterialButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                  child: const Text('Change'),
                                  onPressed: () {
                                    setState(
                                      () {
                                        box.putAt(
                                          index,
                                          ToDoModel(
                                              title: titleController.value.text,
                                              describe:
                                                  describeController.value.text,
                                              isSelected: false),
                                        );
                                        titleController.text = '';
                                        describeController.text = '';
                                      },
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, value, child) {
          if (box.isEmpty) {
            return const Center(child: Text('NOT TASK'));
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 8,
              ),
              itemCount: box.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: box.getAt(index)!.isSelected == false
                      ? Colors.greenAccent
                      : Colors.yellow,
                  onLongPress: () {
                    setState(() {
                      isChanged = true;
                      this.index = index;
                      box.putAt(
                        index,
                        ToDoModel(
                          title: box.getAt(index)!.title,
                          describe: box.getAt(index)!.describe,
                          isSelected: true,
                        ),
                      );
                    });
                  },
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(box.getAt(index)!.title),
                      content: Text(box.getAt(index)!.describe),
                      actions: [
                        MaterialButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'),
                        )
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                  // color: Colors.yellow,
                  title: Text(box.getAt(index)!.title),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'add task',
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(width: 3),
                      ),
                      focusColor: Colors.greenAccent,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: describeController,
                    decoration: const InputDecoration(
                      labelText: 'add describe',
                      focusColor: Colors.greenAccent,
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  child: const Text('Add'),
                  onPressed: () {
                    setState(
                      () {
                        box.add(
                          ToDoModel(
                              title: titleController.value.text,
                              describe: describeController.value.text,
                              isSelected: false),
                        );
                        titleController.text = '';
                        describeController.text = '';
                      },
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
