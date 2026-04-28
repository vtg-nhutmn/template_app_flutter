// import 'package:demo/features/notifications/domain/usecases/create_notification_usecase.dart';
// import 'package:demo/features/notifications/presentation/bloc/notification_bloc.dart';
// import 'package:demo/features/notifications/presentation/bloc/notification_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SendBroadcastPage extends StatefulWidget {
//   const SendBroadcastPage({super.key});

//   @override
//   State<SendBroadcastPage> createState() => _SendBroadcastPageState();
// }

// class _SendBroadcastPageState extends State<SendBroadcastPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _bodyController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _bodyController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     context.read<NotificationBloc>().add(
//       NotificationCreateRequested(
//         CreateNotificationParams(
//           title: _titleController.text.trim(),
//           body: _bodyController.text.trim(),
//           type: 'broadcast',
//           isGlobal: true,
//         ),
//       ),
//     );
//     await Future.delayed(const Duration(milliseconds: 500));

//     if (mounted) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Đã gửi thông báo thành công')),
//       );
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Gửi thông báo')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Tiêu đề',
//                   hintText: 'Nhập tiêu đề thông báo',
//                   prefixIcon: Icon(Icons.title),
//                 ),
//                 validator: (v) {
//                   if (v == null || v.trim().isEmpty) {
//                     return 'Vui lòng nhập tiêu đề';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _bodyController,
//                 decoration: const InputDecoration(
//                   labelText: 'Nội dung',
//                   hintText: 'Nhập nội dung thông báo',
//                   prefixIcon: Icon(Icons.message_outlined),
//                   alignLabelWithHint: true,
//                 ),
//                 maxLines: 4,
//                 validator: (v) {
//                   if (v == null || v.trim().isEmpty) {
//                     return 'Vui lòng nhập nội dung';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 32),
//               FilledButton.icon(
//                 onPressed: _isLoading ? null : _submit,
//                 icon: _isLoading
//                     ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Icon(Icons.send),
//                 label: Text(_isLoading ? 'Đang gửi...' : 'Gửi thông báo'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
