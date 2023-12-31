import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/Todo/domain/entities/notes_entity.dart';
import 'package:notes_app/Todo/presentation/manager/notes_cubit.dart';
import 'package:notes_app/Todo/presentation/widgets/colors_note_items.dart';
import 'package:notes_app/Todo/presentation/widgets/custom_arrow_bar.dart';
import 'package:notes_app/utils/components/components.dart';

class EditNote extends StatefulWidget {
  final NoteEntity noteModel;

  const EditNote({Key? key, required this.noteModel}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  Color? selectedColor;

  @override
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<NotesCubit>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            const CustomArrowBar(),
            Expanded(
              child: ListView(
                children: [
                  BuildColorItem(
                    selectedColor: selectedColor,
                    onSelectColor: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                  ),
                  myTextField(
                    controller: titleController,
                    title: widget.noteModel.title ?? '',
                    color: Colors.grey,
                    size: 30,
                    border: InputBorder.none,
                  ),
                  myTextField(
                    controller: subTitleController,
                    title: widget.noteModel.subTitle ?? '',
                    color: Colors.grey,
                    size: 16,
                    border: InputBorder.none,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cubit.showConfirmationDialog(() {
            final newTitle = titleController.text.trim();
            final newSubTitle = subTitleController.text.trim();

            if (newTitle.isNotEmpty) {
              widget.noteModel.title = newTitle;
            }
            if (newSubTitle.isNotEmpty) {
              widget.noteModel.subTitle = newSubTitle;
            }
            widget.noteModel.color = selectedColor?.value ?? widget.noteModel.color;
            widget.noteModel.save();
            Navigator.pop(context);
            cubit.getNotes();
          }, context);
        },
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.check),
      ),
    );
  }
}
