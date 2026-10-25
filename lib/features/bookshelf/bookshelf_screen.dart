import 'package:flutter/material.dart';

class BookshelfScreen extends StatefulWidget {
  const BookshelfScreen({Key? key}) : super(key: key);

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Kệ sách của tôi',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 1. Phanchua muc tieu doc
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green[800],
                      radius: 20,
                      child: const Text(
                        '9/24',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mục tiêu đọc 2026',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Đã đọc 9 cuốn - còn 15 cuốn',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 2. Thanh chuyen Tab
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Muốn đọc • 14'),
                    Tab(text: 'Đang đọc • 2'),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 3. Danh sach sach
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab Muon doc
                    const Center(
                      child: Text('Danh sách muốn đọc'),
                    ),

                    // Tab Dang doc
                    ListView(
                      children: [
                        // Cuon sach 1
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 55,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.orange[800],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Dune',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Dune',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Text(
                                      'Frank Herbert',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'kết thúc sau 4 ngày',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearProgressIndicator(
                                      value: 0.6,
                                      color: Colors.green,
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Cuon sach 2
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 55,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.brown[700],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Dế Mèn',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Dế Mèn phiêu lưu ký',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Text(
                                      'Tô Hoài',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Còn 20 trang',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearProgressIndicator(
                                      value: 0.85,
                                      color: Colors.green,
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. Nut them sach ISBN
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18, color: Colors.grey),
                label: const Text(
                  '+ Thêm sách bằng mã ISBN',
                  style: TextStyle(color: Colors.grey),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}