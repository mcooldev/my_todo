import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo/models/task_model.dart';
import 'package:my_todo/providers/task_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///
  static final now = DateTime.now();
  final isMorningTime = (now.hour >= 5 && now.hour < 20);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<TaskProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xfff2f4f7),

      /*App bar content*/
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f4f7),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: SizedBox(),
        ),

        ///
        leadingWidth: 75,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            child: Text(
              "👨🏾‍💻",
              style: GoogleFonts.manrope(
                fontSize: 32,
                color: const Color(0xff454545),
              ),
            ),
          ),
        ),

        ///
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isMorningTime ? "Bonjour 👋🏾" : "Bonsoir 👋🏾",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xff454545),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Mouhamadou",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),

        ///
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) {
                  return SafeArea(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          ///
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Nouvelle tâche",
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: const Color(0xfff2f4f7),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          ///
                          TextFormField(
                            controller: taskProv.titleController,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Titre de la tâche",
                              filled: true,
                              fillColor: const Color(0xfff2f4f7),
                            ),
                          ),
                          const SizedBox(height: 12),

                          ///
                          MaterialButton(
                            onPressed: () async {
                              final task = Task(
                                title: taskProv.titleController.text,
                              );
                              await taskProv.createTask(task);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            height: 50,
                            minWidth: double.infinity,
                            color: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  "Ajouter la tâche",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: Colors.white,
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),

      /*Body content*/
      body: Consumer<TaskProvider>(
        builder: (_, taskProvider, _) {
          if (taskProvider.isLoading) {
            return Center(
              child: Column(
                children: [
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 8),
                  Text(
                    "Chargement ...",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: const Color(0xff777777),
                    ),
                  ),
                ],
              ),
            );
          } else if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.slash_circle_fill,
                      size: 70,
                      color: Color(0xffdcdfe3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Vous n'avez pas de tâches pour le moment.",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xff777777),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) {
                            return SafeArea(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                padding: const EdgeInsets.all(16),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ///
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Nouvelle tâche",
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            height: 44,
                                            width: 44,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              color: const Color(0xfff2f4f7),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),

                                    ///
                                    TextFormField(
                                      controller: taskProv.titleController,
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 14,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            90,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: "Titre de la tâche",
                                        filled: true,
                                        fillColor: const Color(0xfff2f4f7),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    ///
                                    MaterialButton(
                                      onPressed: () async {
                                        final task = Task(
                                          title:
                                              taskProvider.titleController.text,
                                        );
                                        await taskProvider.createTask(task);
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      height: 50,
                                      minWidth: double.infinity,
                                      color: Colors.black,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(90),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Ajouter la tâche",
                                            style: GoogleFonts.inter(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      color: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Créer une nouvelle tâche",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mes tâches (${taskProvider.tasks.length})",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (ctx, i) {
                        final task = taskProvider.tasks[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            minTileHeight: 70,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            tileColor: Colors.white,
                            leading: IconButton(
                              onPressed: () {
                                taskProvider.setTaskAsComplete(i);
                              },
                              icon: task.completed
                                  ? const Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank_rounded,
                                    ),
                            ),
                            title: Text(
                              task.title,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                // todo: remove task function
                                taskProvider.removeTask(task.id!);
                              },
                              icon: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.red,
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
          }
        },
      ),
    );
  }
}
