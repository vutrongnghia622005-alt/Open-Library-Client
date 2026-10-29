import '../models/book.dart';

class BookEnrichmentData {
  static const Map<String, Map<String, dynamic>> _catalogExtra = {
    '/works/OL17930368W': {
      'authorIds': ['/authors/OL7527636A'],
      'ratingAverage': 4.8,
      'ratingCount': 14250,
      'originalTitle': 'Atomic Habits: An Easy & Proven Way to Build Good Habits & Break Bad Ones',
      'quote': 'Bạn không đạt đến tầm của những mục tiêu; bạn rơi xuống ngang mức của những thói quen.',
      'subjectPlaces': ['Hoa Kỳ', 'Toàn cầu'],
      'subjectPeople': ['James Clear'],
      'subjectTimes': ['Thế kỷ 21'],
    },
    '/works/OL10263W': {
      'authorIds': ['/authors/OL19158A'],
      'ratingAverage': 4.9,
      'ratingCount': 28500,
      'originalTitle': 'Le Petit Prince',
      'quote': 'Người ta chỉ nhìn rõ được bằng trái tim. Điều cốt lõi thì vô hình trong mắt trần.',
      'subjectPlaces': ['Sa mạc Sahara', 'Tiểu hành tinh B-612'],
      'subjectPeople': ['Hoàng tử bé', 'Người phi công', 'Con cáo', 'Bông hoa hồng', 'Bạch xà'],
      'subjectTimes': ['Những năm 1940'],
    },
    '/works/OL82563W': {
      'authorIds': ['/authors/OL23919A'],
      'ratingAverage': 4.8,
      'ratingCount': 52400,
      'originalTitle': "Harry Potter and the Philosopher's Stone",
      'quote': 'Không thể cứ chìm đắm trong những giấc mơ mà quên đi thực tại cuộc sống.',
      'subjectPlaces': ['Trường Hogwarts', 'Hẻm Xéo', 'Số 4 Privet Drive', 'London'],
      'subjectPeople': ['Harry Potter', 'Ron Weasley', 'Hermione Granger', 'Albus Dumbledore', 'Voldemort'],
      'subjectTimes': ['Thập niên 1990'],
    },
    '/works/OL1168083W': {
      'authorIds': ['/authors/OL118077A'],
      'ratingAverage': 4.7,
      'ratingCount': 35100,
      'originalTitle': 'Nineteen Eighty-Four',
      'quote': 'Kẻ nào kiểm soát quá khứ thì kiểm soát tương lai. Kẻ nào kiểm soát hiện tại thì kiểm soát quá khứ.',
      'subjectPlaces': ['London', 'Đường băng Một (Airstrip One)', 'Đại dương quốc (Oceania)'],
      'subjectPeople': ['Winston Smith', 'Julia', "O'Brien", 'Anh Cả (Big Brother)', 'Goldstein'],
      'subjectTimes': ['Năm 1984 (Hậu tận thế giả định)'],
    },
    '/works/OL66554W': {
      'authorIds': ['/authors/OL21594A'],
      'ratingAverage': 4.8,
      'ratingCount': 42600,
      'originalTitle': 'Pride and Prejudice',
      'quote': 'Có một sự thật được toàn vũ trụ công nhận, rằng một người đàn ông độc thân sở hữu một gia tài lớn hẳn phải cần một người vợ.',
      'subjectPlaces': ['Hertfordshire', 'Derbyshire (Pemberley)', 'London', 'Anh Quốc'],
      'subjectPeople': ['Elizabeth Bennet', 'Fitzwilliam Darcy', 'Jane Bennet', 'Charles Bingley', 'George Wickham'],
      'subjectTimes': ['Đầu thế kỷ 19 (Thời kỳ Regency)'],
    },
    '/works/OL468431W': {
      'authorIds': ['/authors/OL234664A'],
      'ratingAverage': 4.5,
      'ratingCount': 25800,
      'originalTitle': 'The Great Gatsby',
      'quote': 'Vì thế chúng tôi vẫn chèo, những con thuyền ngược dòng, không ngừng bị đẩy lùi về quá khứ.',
      'subjectPlaces': ['West Egg', 'East Egg', 'Long Island', 'New York'],
      'subjectPeople': ['Jay Gatsby', 'Nick Carraway', 'Daisy Buchanan', 'Tom Buchanan', 'Jordan Baker'],
      'subjectTimes': ['Kỷ nguyên Jazz (Những năm 1920)'],
    },
    '/works/OL3140822W': {
      'authorIds': ['/authors/OL395874A'],
      'ratingAverage': 4.8,
      'ratingCount': 38900,
      'originalTitle': 'To Kill a Mockingbird',
      'quote': 'Con không bao giờ thực sự hiểu một người cho đến khi con nhìn sự việc từ góc độ của người ấy... chui vào da của họ và đi lại trong đó.',
      'subjectPlaces': ['Maycomb', 'Alabama', 'Miền Nam Hoa Kỳ'],
      'subjectPeople': ['Scout Finch', 'Atticus Finch', 'Jem Finch', 'Boo Radley', 'Tom Robinson'],
      'subjectTimes': ['Thập niên 1930 (Thời kỳ Đại khủng hoảng)'],
    },
    '/works/OL1095427W': {
      'authorIds': ['/authors/OL31379A'],
      'ratingAverage': 4.7,
      'ratingCount': 29400,
      'originalTitle': 'Jane Eyre: An Autobiography',
      'quote': 'Tôi không phải là một con chim; và không có chiếc bẫy nào giam cầm được tôi; tôi là một con người tự do với ý chí độc lập.',
      'subjectPlaces': ['Thornfield Hall', 'Gateshead Hall', 'Lowood School', 'Anh Quốc'],
      'subjectPeople': ['Jane Eyre', 'Edward Rochester', 'St. John Rivers', 'Bà Reed', 'Bertha Mason'],
      'subjectTimes': ['Thế kỷ 19 (Thời kỳ Victoria)'],
    },
    '/works/OL29983W': {
      'authorIds': ['/authors/OL24529A'],
      'ratingAverage': 4.6,
      'ratingCount': 24700,
      'originalTitle': 'Little Women',
      'quote': 'Tôi không sợ những cơn bão, vì tôi đang học cách điều khiển con tàu của chính mình.',
      'subjectPlaces': ['Concord', 'Massachusetts', 'New England', 'Hoa Kỳ'],
      'subjectPeople': ['Jo March', 'Meg March', 'Beth March', 'Amy March', 'Laurie Laurence', 'Bà March'],
      'subjectTimes': ['Thời kỳ Nội chiến Hoa Kỳ (1861-1865)'],
    },
    '/works/OL1168007W': {
      'authorIds': ['/authors/OL118077A'],
      'ratingAverage': 4.6,
      'ratingCount': 33200,
      'originalTitle': 'Animal Farm: A Fairy Story',
      'quote': 'Mọi con vật đều bình đẳng, nhưng một số con vật bình đẳng hơn những con vật khác.',
      'subjectPlaces': ['Nông trại Manor / Nông trại Động vật', 'Anh Quốc'],
      'subjectPeople': ['Napoleon', 'Snowball', 'Boxer', 'Squealer', 'Old Major', 'Ông Jones'],
      'subjectTimes': ['Thế kỷ 20 (Ẩn dụ cách mạng)'],
    },
    '/works/OL796465W': {
      'authorIds': ['/authors/OL19747A'],
      'ratingAverage': 4.7,
      'ratingCount': 31800,
      'originalTitle': 'O Alquimista',
      'quote': 'Khi bạn khao khát một điều gì đó, cả vũ trụ sẽ hợp lực giúp bạn đạt được điều đó.',
      'subjectPlaces': ['Andalusia (Tây Ban Nha)', 'Tangier', 'Sa mạc Sahara', 'Kim tự tháp Ai Cập'],
      'subjectPeople': ['Santiago', 'Nhà Giả Kim', 'Melchizedek (Vua xứ Salem)', 'Fatima'],
      'subjectTimes': ['Thời kỳ tiền hiện đại'],
    },
    '/works/OL27482W': {
      'authorIds': ['/authors/OL26320A'],
      'ratingAverage': 4.8,
      'ratingCount': 37500,
      'originalTitle': 'The Hobbit, or There and Back Again',
      'quote': 'Nếu có thêm nhiều người quý trọng thức ăn, sự vui vẻ và bài ca hơn là vàng bạc tích trữ, thế giới này sẽ hạnh phúc hơn nhiều.',
      'subjectPlaces': ['The Shire', 'Rivendell', 'Rừng Mirkwood', 'Núi Cô Đơn (Erebor)'],
      'subjectPeople': ['Bilbo Baggins', 'Gandalf', 'Thorin Oakenshield', 'Smaug', 'Gollum'],
      'subjectTimes': ['Kỷ Đệ Tam của Trung Địa'],
    },
    '/works/OL27513W': {
      'authorIds': ['/authors/OL26320A'],
      'ratingAverage': 4.8,
      'ratingCount': 41200,
      'originalTitle': 'The Fellowship of the Ring',
      'quote': 'Không phải tất cả những ai lang thang đều lạc lối; những cội rễ sâu không bao giờ bị băng giá làm hại.',
      'subjectPlaces': ['The Shire', 'Bree', 'Rivendell', 'Hầm mỏ Moria', 'Lothlórien'],
      'subjectPeople': ['Frodo Baggins', 'Samwise Gamgee', 'Gandalf', 'Aragorn', 'Legolas', 'Gimli', 'Boromir'],
      'subjectTimes': ['Cuộc chiến Nhẫn Giả (Kỷ Đệ Tam)'],
    },
    '/works/OL71037W': {
      'authorIds': ['/authors/OL31102A'],
      'ratingAverage': 4.7,
      'ratingCount': 26300,
      'originalTitle': 'The Lion, the Witch and the Wardrobe',
      'quote': 'Một ngày nào đó con sẽ đủ lớn để bắt đầu đọc lại những câu chuyện cổ tích.',
      'subjectPlaces': ['Xứ sở Narnia', 'Tủ áo ma thuật', 'Lâu đài Cair Paravel', 'Bàn Đá'],
      'subjectPeople': ['Aslan', 'Lucy Pevensie', 'Edmund Pevensie', 'Peter Pevensie', 'Susan Pevensie', 'Phù thủy Trắng'],
      'subjectTimes': ['Thế chiến II / Thời đại Hoàng kim Narnia'],
    },
    '/works/OL893414W': {
      'authorIds': ['/authors/OL28994A'],
      'ratingAverage': 4.7,
      'ratingCount': 23900,
      'originalTitle': 'Dune',
      'quote': 'Ta không được sợ hãi. Nỗi sợ hãi là kẻ giết chết tâm trí.',
      'subjectPlaces': ['Hành tinh sa mạc Arrakis', 'Caladan', 'Giedi Prime'],
      'subjectPeople': ['Paul Atreides', 'Lady Jessica', 'Công tước Leto Atreides', 'Baron Harkonnen', 'Chani'],
      'subjectTimes': ['Năm 10191 trong tương lai xa'],
    },
    '/works/OL64365W': {
      'authorIds': ['/authors/OL19745A'],
      'ratingAverage': 4.5,
      'ratingCount': 21500,
      'originalTitle': 'Brave New World',
      'quote': 'Ngôn từ có thể giống như tia X, nếu sử dụng đúng cách, chúng sẽ xuyên qua mọi thứ.',
      'subjectPlaces': ['London (Nhà nước Thế giới)', 'Khu bảo tồn Malpais (New Mexico)'],
      'subjectPeople': ['Bernard Marx', 'John the Savage', 'Lenina Crowne', 'Mustapha Mond'],
      'subjectTimes': ['Năm 632 Kỷ nguyên Ford (2540 CN)'],
    },
    '/works/OL103123W': {
      'authorIds': ['/authors/OL22234A'],
      'ratingAverage': 4.6,
      'ratingCount': 22800,
      'originalTitle': 'Fahrenheit 451',
      'quote': 'Bạn không cần phải đốt sách để phá hủy một nền văn hóa. Chỉ cần làm cho mọi người ngừng đọc chúng.',
      'subjectPlaces': ['Một thành phố tương lai tại Hoa Kỳ'],
      'subjectPeople': ['Guy Montag', 'Clarisse McClellan', 'Đội trưởng Beatty', 'Mildred Montag', 'Faber'],
      'subjectTimes': ['Thế kỷ 24'],
    },
    '/works/OL450063W': {
      'authorIds': ['/authors/OL443190A'],
      'ratingAverage': 4.6,
      'ratingCount': 27400,
      'originalTitle': 'Frankenstein; or, The Modern Prometheus',
      'quote': 'Cẩn thận đấy; vì ta không biết sợ hãi, và do đó ta là kẻ vô cùng mạnh mẽ.',
      'subjectPlaces': ['Geneva (Thụy Sĩ)', 'Ingolstadt (Đức)', 'Bắc Băng Dương'],
      'subjectPeople': ['Victor Frankenstein', 'Quái vật Frankenstein', 'Robert Walton', 'Elizabeth Lavenza'],
      'subjectTimes': ['Thế kỷ 18'],
    },
    '/works/OL85892W': {
      'authorIds': ['/authors/OL24199A'],
      'ratingAverage': 4.7,
      'ratingCount': 28900,
      'originalTitle': 'Dracula',
      'quote': 'Chúng ta học được từ sự thất bại, chứ không phải từ thành công!',
      'subjectPlaces': ['Lâu đài Dracula (Transylvania, Romania)', 'Whitby', 'London (Anh Quốc)'],
      'subjectPeople': ['Bá tước Dracula', 'Jonathan Harker', 'Mina Harker', 'Giáo sư Abraham Van Helsing'],
      'subjectTimes': ['Cuối thế kỷ 19 (Thời kỳ Victoria)'],
    },
    '/works/OL471565W': {
      'authorIds': ['/authors/OL27695A'],
      'ratingAverage': 4.8,
      'ratingCount': 34800,
      'originalTitle': 'And Then There Were None',
      'quote': 'Tội lỗi không bao giờ biến mất; nó chỉ nằm chờ đợi cơ hội để trừng phạt kẻ phạm tội.',
      'subjectPlaces': ['Đảo Soldier (Đảo Người lính)', 'Devon', 'Anh Quốc'],
      'subjectPeople': ['Vera Claythorne', 'Philip Lombard', 'Thẩm phán Lawrence Wargrave', 'Bác sĩ Armstrong'],
      'subjectTimes': ['Tháng 8 năm 1939'],
    },
    '/works/OL471576W': {
      'authorIds': ['/authors/OL27695A'],
      'ratingAverage': 4.7,
      'ratingCount': 31400,
      'originalTitle': 'Murder on the Orient Express',
      'quote': 'Điều bất khả thi không thể xảy ra, do đó điều tưởng chừng bất khả thi phải khả thi bất chấp mọi vẻ bề ngoài.',
      'subjectPlaces': ['Tàu tốc hành Phương Đông (Orient Express)', 'Vinkovci', 'Nam Tư cũ'],
      'subjectPeople': ['Hercule Poirot', 'M. Bouc', 'Bác sĩ Constantine', 'Samuel Ratchett', 'Bà Hubbard'],
      'subjectTimes': ['Mùa đông năm 1934'],
    },
    '/works/OL262421W': {
      'authorIds': ['/authors/OL262354A'],
      'ratingAverage': 4.8,
      'ratingCount': 36700,
      'originalTitle': 'The Adventures of Sherlock Holmes',
      'quote': 'Khi bạn đã loại trừ những điều không thể, thì bất cứ điều gì còn lại, dù khó tin đến đâu, phải là sự thật.',
      'subjectPlaces': ['221B Baker Street', 'London', 'Nước Anh thời Victoria'],
      'subjectPeople': ['Sherlock Holmes', 'Bác sĩ John H. Watson', 'Irene Adler', 'Thanh tra Lestrade'],
      'subjectTimes': ['Cuối thế kỷ 19'],
    },
    '/works/OL262454W': {
      'authorIds': ['/authors/OL262354A'],
      'ratingAverage': 4.7,
      'ratingCount': 28500,
      'originalTitle': 'The Hound of the Baskervilles',
      'quote': 'Thế giới này chứa đầy những điều hiển nhiên mà chẳng một ai từng bận tâm quan sát.',
      'subjectPlaces': ['Đầm lầy Dartmoor', 'Lâu đài Baskerville Hall', 'Devon', 'Anh Quốc'],
      'subjectPeople': ['Sherlock Holmes', 'Bác sĩ Watson', 'Sir Henry Baskerville', 'Jack Stapleton'],
      'subjectTimes': ['Mùa thu năm 1889'],
    },
    '/works/OL138052W': {
      'authorIds': ['/authors/OL22098A'],
      'ratingAverage': 4.6,
      'ratingCount': 25300,
      'originalTitle': "Alice's Adventures in Wonderland",
      'quote': 'Tôi không thể quay trở lại ngày hôm qua, vì lúc đó tôi là một người hoàn toàn khác.',
      'subjectPlaces': ['Xứ sở thần tiên (Wonderland)', 'Bờ sông nước Anh'],
      'subjectPeople': ['Alice', 'Thỏ Trắng', 'Mèo Cheshire', 'Người làm mũ điên (Mad Hatter)', 'Nữ hoàng Cơ'],
      'subjectTimes': ['Thời kỳ Victoria (1865)'],
    },
    '/works/OL483391W': {
      'authorIds': ['/authors/OL22204A'],
      'ratingAverage': 4.7,
      'ratingCount': 21200,
      'originalTitle': "Charlotte's Web",
      'quote': 'Không phải mỗi ngày đều tìm được một người bạn chân thành, một người vừa là bạn tốt vừa là nhà văn cừ khôi.',
      'subjectPlaces': ['Trang trại Zuckerman', 'Hội chợ Hạt', 'Maine', 'Hoa Kỳ'],
      'subjectPeople': ['Nhện Charlotte', 'Chú heo Wilbur', 'Cô bé Fern Arable', 'Chuột Templeton'],
      'subjectTimes': ['Giữa thế kỷ 20'],
    },
    '/works/OL45846W': {
      'authorIds': ['/authors/OL34184A'],
      'ratingAverage': 4.8,
      'ratingCount': 26900,
      'originalTitle': 'Matilda',
      'quote': 'Những cuốn sách đã đưa cô bé đến những thế giới mới và giới thiệu cô với những con người kỳ thú sống một cuộc đời đầy phấn khích.',
      'subjectPlaces': ['Ngôi làng ở Buckinghamshire', 'Trường tiểu học Crunchem Hall', 'Anh Quốc'],
      'subjectPeople': ['Matilda Wormwood', 'Cô giáo Honey', 'Hiệu trưởng Trunchbull', 'Ông bà Wormwood'],
      'subjectTimes': ['Những năm 1980'],
    },
    '/works/OL1063267W': {
      'authorIds': ['/authors/OL32470A'],
      'ratingAverage': 4.7,
      'ratingCount': 39100,
      'originalTitle': 'How to Win Friends and Influence People',
      'quote': 'Cách duy nhất để đạt được điều tốt nhất trong một cuộc tranh cãi là tránh nó hoàn toàn.',
      'subjectPlaces': ['New York', 'Hoa Kỳ', 'Toàn cầu'],
      'subjectPeople': ['Dale Carnegie', 'Abraham Lincoln', 'Theodore Roosevelt'],
      'subjectTimes': ['Thập niên 1930 - Hiện đại'],
    },
    '/works/OL2629977W': {
      'authorIds': ['/authors/OL39213A'],
      'ratingAverage': 4.7,
      'ratingCount': 28300,
      'originalTitle': 'The 7 Habits of Highly Effective People',
      'quote': 'Hầu hết mọi người không lắng nghe với ý định thấu hiểu; họ lắng nghe với ý định đáp trả.',
      'subjectPlaces': ['Hoa Kỳ', 'Toàn cầu'],
      'subjectPeople': ['Stephen R. Covey'],
      'subjectTimes': ['Cuối thế kỷ 20'],
    },
    '/works/OL17713267W': {
      'authorIds': ['/authors/OL7017646A'],
      'ratingAverage': 4.7,
      'ratingCount': 18400,
      'originalTitle': 'Deep Work: Rules for Focused Success in a Distracted World',
      'quote': 'Khả năng thực hiện công việc chuyên sâu ngày càng trở nên hiếm hoi nhưng lại ngày càng có giá trị trong nền kinh tế mới.',
      'subjectPlaces': ['Hoa Kỳ'],
      'subjectPeople': ['Cal Newport', 'Carl Jung', 'Bill Gates'],
      'subjectTimes': ['Thế kỷ 21'],
    },
    '/works/OL21640039W': {
      'authorIds': ['/authors/OL8123282A'],
      'ratingAverage': 4.8,
      'ratingCount': 21700,
      'originalTitle': 'The Psychology of Money: Timeless lessons on wealth, greed, and happiness',
      'quote': 'Làm tốt về mặt tài chính không nhất thiết liên quan đến việc bạn thông minh cỡ nào, mà liên quan đến cách bạn hành xử.',
      'subjectPlaces': ['Wall Street', 'Hoa Kỳ'],
      'subjectPeople': ['Morgan Housel', 'Warren Buffett', 'Charlie Munger'],
      'subjectTimes': ['Thế kỷ 21'],
    },
  };

  static const Map<String, BookAuthor> _authors = {
    '/authors/OL7527636A': BookAuthor(
      id: '/authors/OL7527636A',
      name: 'James Clear',
      birthDate: '22/01/1986',
      biography: 'Tác giả, diễn giả nổi tiếng người Mỹ chuyên nghiên cứu về thói quen, việc ra quyết định và cải thiện bản thân liên tục. Tác phẩm Atomic Habits đã bán được hàng triệu bản trên toàn thế giới.',
    ),
    '/authors/OL19158A': BookAuthor(
      id: '/authors/OL19158A',
      name: 'Antoine de Saint-Exupéry',
      birthDate: '29/06/1900',
      deathDate: '31/07/1944',
      biography: 'Nhà văn, nhà thơ và phi công tiên phong người Pháp. Ông nổi tiếng với kiệt tác thiếu nhi mang triết lý sâu sắc Hoàng tử bé (Le Petit Prince), được dịch ra hàng trăm ngôn ngữ.',
    ),
    '/authors/OL23919A': BookAuthor(
      id: '/authors/OL23919A',
      name: 'J. K. Rowling',
      birthDate: '31/07/1965',
      biography: 'Nhà văn, nhà từ thiện và nhà sản xuất phim người Anh. Bà nổi tiếng khắp thế giới với tư cách là tác giả của bộ truyện kỳ ảo Harry Potter, một trong những bộ sách bán chạy nhất lịch sử.',
    ),
    '/authors/OL118077A': BookAuthor(
      id: '/authors/OL118077A',
      name: 'George Orwell',
      birthDate: '25/06/1903',
      deathDate: '21/01/1950',
      biography: 'Bút danh của Eric Arthur Blair, tiểu thuyết gia, nhà báo và nhà phê bình người Anh. Tác phẩm của ông mang đậm tính phê phán xã hội, nổi bật nhất là 1984 và Trại súc vật (Animal Farm).',
    ),
    '/authors/OL21594A': BookAuthor(
      id: '/authors/OL21594A',
      name: 'Jane Austen',
      birthDate: '16/12/1775',
      deathDate: '18/07/1817',
      biography: 'Tiểu thuyết gia người Anh thời kỳ Regency, bậc thầy về văn phong châm biếm, hiện thực và nghệ thuật phân tích tâm lý nhân vật qua các tác phẩm kinh điển như Kiêu hãnh và định kiến.',
    ),
    '/authors/OL234664A': BookAuthor(
      id: '/authors/OL234664A',
      name: 'F. Scott Fitzgerald',
      birthDate: '24/09/1896',
      deathDate: '21/12/1940',
      biography: 'Đại văn hào người Mỹ thuộc Thế hệ mất mát (Lost Generation). Ông khắc họa xuất sắc hào quang và sự suy đồi của Kỷ nguyên Jazz qua kiệt tác Gatsby vĩ đại (The Great Gatsby).',
    ),
    '/authors/OL395874A': BookAuthor(
      id: '/authors/OL395874A',
      name: 'Harper Lee',
      birthDate: '28/04/1926',
      deathDate: '19/02/2016',
      biography: 'Nữ nhà văn Mỹ đoạt giải Pulitzer văn học danh giá năm 1961 với kiệt tác Giết con chim nhại (To Kill a Mockingbird), một tác phẩm xúc động về công lý, bình đẳng và lòng nhân ái.',
    ),
    '/authors/OL31379A': BookAuthor(
      id: '/authors/OL31379A',
      name: 'Charlotte Brontë',
      birthDate: '21/04/1816',
      deathDate: '31/03/1855',
      biography: 'Tiểu thuyết gia và nhà thơ người Anh, người chị cả trong ba chị em nhà Brontë lừng danh. Bà là tác giả của cuốn tiểu thuyết kinh điển Jane Eyre.',
    ),
    '/authors/OL24529A': BookAuthor(
      id: '/authors/OL24529A',
      name: 'Louisa May Alcott',
      birthDate: '29/11/1832',
      deathDate: '06/03/1888',
      biography: 'Nữ văn sĩ người Mỹ nổi tiếng thế giới với tác phẩm Những người phụ nữ bé nhỏ (Little Women), câu chuyện ấm áp về tình cảm gia đình và nghị lực vươn lên của bốn chị em gái.',
    ),
    '/authors/OL19747A': BookAuthor(
      id: '/authors/OL19747A',
      name: 'Paulo Coelho',
      birthDate: '24/08/1947',
      biography: 'Tiểu thuyết gia người Brazil, một trong những tác giả có sách bán chạy nhất thế giới. Tác phẩm Nhà giả kim (The Alchemist) đã truyền cảm hứng sống cho hàng triệu độc giả toàn cầu.',
    ),
    '/authors/OL26320A': BookAuthor(
      id: '/authors/OL26320A',
      name: 'J. R. R. Tolkien',
      birthDate: '03/01/1892',
      deathDate: '02/09/1973',
      biography: 'Giáo sư, nhà ngữ văn và tác giả vĩ đại người Anh. Ông là cha đẻ của thần thoại Trung Địa với các tác phẩm huyền thoại như Anh chàng Hobbit và Chúa tể những chiếc nhẫn.',
    ),
    '/authors/OL31102A': BookAuthor(
      id: '/authors/OL31102A',
      name: 'C. S. Lewis',
      birthDate: '29/11/1898',
      deathDate: '22/11/1963',
      biography: 'Học giả, nhà phê bình văn học và tác giả người Anh gốc Ireland. Ông sáng tạo nên bộ biên niên sử kỳ ảo kinh điển Biên niên sử Narnia gồm 7 tập.',
    ),
    '/authors/OL28994A': BookAuthor(
      id: '/authors/OL28994A',
      name: 'Frank Herbert',
      birthDate: '08/10/1920',
      deathDate: '11/02/1986',
      biography: 'Tác giả khoa học viễn tưởng vĩ đại người Mỹ. Kiệt tác Xứ Cát (Dune) của ông mở đầu cho bộ sử thi không gian đồ sộ, khám phá sự đan xen giữa sinh thái, tôn giáo và quyền lực.',
    ),
    '/authors/OL19745A': BookAuthor(
      id: '/authors/OL19745A',
      name: 'Aldous Huxley',
      birthDate: '26/07/1894',
      deathDate: '22/11/1963',
      biography: 'Nhà văn và triết gia người Anh, tác giả của tiểu thuyết phản địa đàng chấn động Brave New World (Thế giới mới tươi đẹp).',
    ),
    '/authors/OL22234A': BookAuthor(
      id: '/authors/OL22234A',
      name: 'Ray Bradbury',
      birthDate: '22/08/1920',
      deathDate: '05/06/2012',
      biography: 'Bậc thầy tiểu thuyết gia người Mỹ trong thể loại khoa học viễn tưởng, kỳ ảo và kinh dị, nổi tiếng nhất với cuốn sách cảnh tỉnh 451 độ F (Fahrenheit 451).',
    ),
    '/authors/OL443190A': BookAuthor(
      id: '/authors/OL443190A',
      name: 'Mary Shelley',
      birthDate: '30/08/1797',
      deathDate: '01/02/1851',
      biography: 'Nữ văn sĩ người Anh, người tiên phong mở ra thể loại khoa học viễn tưởng hiện đại khi sáng tác tiểu thuyết Frankenstein ở tuổi đôi mươi.',
    ),
    '/authors/OL24199A': BookAuthor(
      id: '/authors/OL24199A',
      name: 'Bram Stoker',
      birthDate: '08/11/1847',
      deathDate: '20/04/1912',
      biography: 'Tác giả người Ireland, người đã sáng tạo ra nhân vật ma cà rồng Bá tước Dracula huyền thoại trong cuốn tiểu thuyết Gothic kinh điển cùng tên xuất bản năm 1897.',
    ),
    '/authors/OL27695A': BookAuthor(
      id: '/authors/OL27695A',
      name: 'Agatha Christie',
      birthDate: '15/09/1890',
      deathDate: '12/01/1976',
      biography: 'Nữ hoàng truyện trinh thám người Anh với 66 tiểu thuyết trinh thám và 14 tuyển tập truyện ngắn, là một trong những tác giả bán chạy nhất mọi thời đại.',
    ),
    '/authors/OL262354A': BookAuthor(
      id: '/authors/OL262354A',
      name: 'Arthur Conan Doyle',
      birthDate: '22/05/1859',
      deathDate: '07/07/1930',
      biography: 'Bác sĩ và nhà văn người Scotland, cha đẻ của vị thám tử đại tài Sherlock Holmes và bác sĩ Watson, nhân vật trinh thám nổi tiếng nhất thế giới văn học.',
    ),
    '/authors/OL22098A': BookAuthor(
      id: '/authors/OL22098A',
      name: 'Lewis Carroll',
      birthDate: '27/01/1832',
      deathDate: '14/01/1898',
      biography: 'Bút danh của Charles Lutwidge Dodgson, nhà toán học và văn sĩ người Anh, tác giả của cuộc phiêu lưu diệu kỳ Cuộc phiêu lưu của Alice vào Xứ sở thần tiên.',
    ),
    '/authors/OL22204A': BookAuthor(
      id: '/authors/OL22204A',
      name: 'E. B. White',
      birthDate: '11/07/1899',
      deathDate: '01/10/1985',
      biography: 'Nhà văn, nhà viết tiểu luận người Mỹ, tác giả của các cuốn sách thiếu nhi được yêu thích qua nhiều thế hệ như Charlotte và Wilbur (Charlotte\'s Web) và Stuart Little.',
    ),
    '/authors/OL34184A': BookAuthor(
      id: '/authors/OL34184A',
      name: 'Roald Dahl',
      birthDate: '13/09/1916',
      deathDate: '23/11/1990',
      biography: 'Tác giả truyện thiếu nhi huyền thoại người Anh gốc Na Uy, nổi tiếng với sự hóm hỉnh khác thường qua các tác phẩm Matilda, Charlie và nhà máy sô-cô-la, BFG.',
    ),
    '/authors/OL32470A': BookAuthor(
      id: '/authors/OL32470A',
      name: 'Dale Carnegie',
      birthDate: '24/11/1888',
      deathDate: '01/11/1955',
      biography: 'Nhà văn, nhà phát triển các khóa học kỹ năng ứng xử nổi tiếng của Mỹ. Cuốn sách Đắc Nhân Tâm (How to Win Friends and Influence People) của ông là cẩm nang giao tiếp kinh điển.',
    ),
    '/authors/OL39213A': BookAuthor(
      id: '/authors/OL39213A',
      name: 'Stephen R. Covey',
      birthDate: '24/10/1932',
      deathDate: '16/07/2012',
      biography: 'Nhà giáo dục, tác giả và chuyên gia lãnh đạo hàng đầu người Mỹ. Tác phẩm 7 Thói Quen Để Thành Đạt (The 7 Habits of Highly Effective People) đã định hình tư duy quản trị toàn cầu.',
    ),
    '/authors/OL7017646A': BookAuthor(
      id: '/authors/OL7017646A',
      name: 'Cal Newport',
      birthDate: '23/06/1982',
      biography: 'Giáo sư khoa học máy tính tại Đại học Georgetown và tác giả của nhiều cuốn sách về năng suất làm việc sâu như Deep Work, Digital Minimalism.',
    ),
    '/authors/OL8123282A': BookAuthor(
      id: '/authors/OL8123282A',
      name: 'Morgan Housel',
      birthDate: '01/01/1984',
      biography: 'Chuyên gia tài chính, nhà báo và tác giả cuốn Tâm Lý Học Về Tiền (The Psychology of Money). Ông nghiên cứu cách con người hành xử và đưa ra quyết định với tiền bạc.',
    ),
  };

  /// Returns extra curated metadata for a work ID if present.
  static Map<String, dynamic>? getExtraForWork(String workId) =>
      _catalogExtra[workId];

  /// Enriches an existing [Book] instance with curated catalog metadata if available.
  static Book enrich(Book book) {
    final extra = _catalogExtra[book.id];
    if (extra == null) return book;

    final extraAuthorIds = extra['authorIds'] is List
        ? (extra['authorIds'] as List).cast<String>()
        : const <String>[];
    final authorIds = book.authorIds.isNotEmpty ? book.authorIds : extraAuthorIds;

    return Book(
      id: book.id,
      title: book.title,
      authors: book.authors,
      authorIds: authorIds,
      categories: book.categories,
      description: book.description,
      descriptionSource: book.descriptionSource,
      firstPublishYear: book.firstPublishYear,
      coverId: book.coverId,
      coverAsset: book.coverAsset,
      coverEditionKey: book.coverEditionKey,
      coverIsIllustration: book.coverIsIllustration,
      selectedEdition: book.selectedEdition,
      subjectPlaces: book.subjectPlaces.isNotEmpty
          ? book.subjectPlaces
          : (extra['subjectPlaces'] as List?)?.cast<String>() ?? const [],
      subjectPeople: book.subjectPeople.isNotEmpty
          ? book.subjectPeople
          : (extra['subjectPeople'] as List?)?.cast<String>() ?? const [],
      subjectTimes: book.subjectTimes.isNotEmpty
          ? book.subjectTimes
          : (extra['subjectTimes'] as List?)?.cast<String>() ?? const [],
      originalTitle: book.originalTitle ?? extra['originalTitle'] as String?,
      quote: book.quote ?? extra['quote'] as String?,
      ratingAverage: book.ratingAverage ?? (extra['ratingAverage'] as num?)?.toDouble(),
      ratingCount: book.ratingCount ?? extra['ratingCount'] as int?,
    );
  }

  /// Looks up a curated author by canonical Open Library author key.
  static BookAuthor? getAuthorById(String authorId) => _authors[authorId];

  /// Looks up a curated author by author name matching.
  static BookAuthor? getAuthorByName(String name) {
    final clean = name.toLowerCase().trim();
    for (final author in _authors.values) {
      if (author.name != null && author.name!.toLowerCase().trim() == clean) {
        return author;
      }
    }
    // Partial search
    for (final author in _authors.values) {
      if (author.name != null &&
          (clean.contains(author.name!.toLowerCase()) ||
              author.name!.toLowerCase().contains(clean))) {
        return author;
      }
    }
    return null;
  }
}
