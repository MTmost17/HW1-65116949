import 'dart:io';

// Book //
class Book {
  String title;
  String author;
  String isbn;
  int copies;
  int totalCopies; // เพิ่มตัวแปรนี้เพื่อเก็บจำนวนสำเนาทั้งหมดของหนังสือ
  List<String> borrowers = []; // รายชื่อผู้ยืมหนังสือ

  Book(this.title, this.author, this.isbn, this.copies) : totalCopies = copies;

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
    if (copies < totalCopies) {
      copies++;
      borrowers.remove(memberName);
      print('คืนหนังสือ: $title');
    } else {
      print('ไม่สามารถคืนได้: จำนวนสำเนาเกินที่มีอยู่.');
    }
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

  void listMembers() {
    if (members.isEmpty) {
      print('ไม่มีสมาชิกในห้องสมุด.');
    } else {
      for (var member in members) {
        print('ชื่อสมาชิก: ${member.name}, รหัสสมาชิก: ${member.memberId}');
        if (member.borrowedBooks.isNotEmpty) {
          print('หนังสือที่ยืม: ${member.borrowedBooks.map((book) => book.title).join(', ')}');
        }
      }
    }
  }
}

// Menu //
void main() {
  Library library = Library();

  // เพิ่มหนังสือบางเล่มเพื่อการทดสอบ
  library.addBook(Book('หนังสือ A', 'ผู้เขียน A', 'ISBN001', 3));
  library.addBook(Book('หนังสือ B', 'ผู้เขียน B', 'ISBN002', 2));
  library.addBook(Book('หนังสือ C', 'ผู้เขียน C', 'ISBN003', 5));

  // เพิ่มสมาชิกบางคนเพื่อการทดสอบ
  library.registerMember(Member('สมชาย', 'MEM001'));
  library.registerMember(Member('สมหญิง', 'MEM002'));
  library.registerMember(Member('สมปอง', 'MEM003'));

  while (true) {
    print('ระบบจัดการห้องสมุด');
    print('1. เพิ่มหนังสือ');
    print('2. ลบหนังสือ');
    print('3. ลงทะเบียนสมาชิก');
    print('4. ยืมหนังสือ');
    print('5. คืนหนังสือ');
    print('6. แสดงหนังสือทั้งหมด');
    print('7. แสดงสมาชิกทั้งหมด');
    print('8. ออกจากระบบ');
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
        library.listMembers();
        break;
        
      case '8':
        exit(0);
        
      default:
        print('ตัวเลือกไม่ถูกต้อง กรุณาลองใหม่.');
    }
  }
}
