import 'dart:io';

// Book //
class Book {
  String title;
  String author;
  String isbn;
  int copies;
  List<String> borrowers = []; // รายชื่อผู้ยืมหนังสือ

  Book(this.title, this.author, this.isbn, this.copies);

  void borrowBook(String memberName) {
    if (copies > 0) {
      copies--;
      borrowers.add(memberName);
      print('ยืมหนังสือ: $title');
    } else {
      print('ไม่มีสำเนาหนังสือให้ยืมแล้ว.');
    }
  }

  void returnBook(String memberName) {
    copies++;
    borrowers.remove(memberName);
    print('คืนหนังสือ: $title');
  }
}

// Member //
class Member {
  String name;
  String memberId;
  List<Book> borrowedBooks = [];

  Member(this.name, this.memberId);

  void borrowBook(Book book) {
    book.borrowBook(name);
    borrowedBooks.add(book);
  }

  void returnBook(Book book) {
    book.returnBook(name);
    borrowedBooks.remove(book);
  }
}

// Library //
class Library {
  List<Book> books = [];
  List<Member> members = [];

  void addBook(Book book) {
    books.add(book);
    print('เพิ่มหนังสือ: ${book.title}');
  }

  void removeBook(String isbn) {
    try {
      Book book = books.firstWhere((b) => b.isbn == isbn);
      books.remove(book);
      print('ลบหนังสือ: ${book.title}');
    } catch (e) {
      print('ไม่พบหนังสือ.');
    }
  }

  void registerMember(Member member) {
    members.add(member);
    print('ลงทะเบียนสมาชิก: ${member.name}');
  }

  void borrowBook(String memberId, String isbn) {
    try {
      Member member = members.firstWhere((m) => m.memberId == memberId);
      Book book = books.firstWhere((b) => b.isbn == isbn);
      member.borrowBook(book);
    } catch (e) {
      print('ไม่พบสมาชิกหรือหนังสือ.');
    }
  }

  void returnBook(String memberId, String isbn) {
    try {
      Member member = members.firstWhere((m) => m.memberId == memberId);
      Book book = books.firstWhere((b) => b.isbn == isbn);
      member.returnBook(book);
    } catch (e) {
      print('ไม่พบสมาชิกหรือหนังสือ.');
    }
  }

  void listBooks() {
    if (books.isEmpty) {
      print('ไม่มีหนังสือในห้องสมุด.');
    } else {
      for (var book in books) {
        print('ชื่อหนังสือ: ${book.title}, ผู้เขียน: ${book.author}, ISBN: ${book.isbn}, จำนวนสำเนา: ${book.copies}');
        if (book.borrowers.isNotEmpty) {
          print('รายชื่อผู้ยืมหนังสือ: ${book.borrowers.join(', ')}');
        }
      }
    }
  }
}

// Menu //
void main() {
  Library library = Library();

  while (true) {
    print('ระบบจัดการห้องสมุด');
    print('1. เพิ่มหนังสือ');
    print('2. ลบหนังสือ');
    print('3. ลงทะเบียนสมาชิก');
    print('4. ยืมหนังสือ');
    print('5. คืนหนังสือ');
    print('6. แสดงหนังสือทั้งหมด');
    print('7. ออกจากระบบ');
    print('กรุณาเลือกตัวเลือก:');
    
    String? choice = stdin.readLineSync();
    
    switch (choice) {
      case '1':
        print('กรุณาใส่ชื่อหนังสือ:');
        String title = stdin.readLineSync()!;
        print('กรุณาใส่ผู้เขียนหนังสือ:');
        String author = stdin.readLineSync()!;
        print('กรุณาใส่ ISBN ของหนังสือ:');
        String isbn = stdin.readLineSync()!;
        print('กรุณาใส่จำนวนสำเนาของหนังสือ:');
        int copies = int.parse(stdin.readLineSync()!);
        library.addBook(Book(title, author, isbn, copies));
        break;
        
      case '2':
        print('กรุณาใส่ ISBN ของหนังสือที่ต้องการลบ:');
        String isbn = stdin.readLineSync()!;
        library.removeBook(isbn);
        break;
        
      case '3':
        print('กรุณาใส่ชื่อสมาชิก:');
        String name = stdin.readLineSync()!;
        print('กรุณาใส่รหัสสมาชิก:');
        String memberId = stdin.readLineSync()!;
        library.registerMember(Member(name, memberId));
        break;
        
      case '4':
        print('กรุณาใส่รหัสสมาชิก:');
        String memberId = stdin.readLineSync()!;
        print('กรุณาใส่ ISBN ของหนังสือที่ต้องการยืม:');
        String isbn = stdin.readLineSync()!;
        library.borrowBook(memberId, isbn);
        break;
        
      case '5':
        print('กรุณาใส่รหัสสมาชิก:');
        String memberId = stdin.readLineSync()!;
        print('กรุณาใส่ ISBN ของหนังสือที่ต้องการคืน:');
        String isbn = stdin.readLineSync()!;
        library.returnBook(memberId, isbn);
        break;

      case '6':
        library.listBooks();
        break;
        
      case '7':
        exit(0);
        
      default:
        print('ตัวเลือกไม่ถูกต้อง กรุณาลองใหม่.');
    }
  }
}
