//
//  DatabaseManagement.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManagement {
    static let shared: DatabaseManagement = DatabaseManagement()
    private let db: Connection?
    
    // Table Category
    private let tblCategory = Table("category")
    private let cat_id = Expression<Int64>("id")
    private let cat_name_en = Expression<String?>("name_en")
    private let cat_name_vn = Expression<String?>("name_vn")
    
    // Table Type of Word
    private let tblTypeofWord = Table("typeofword")
    private let type_id = Expression<Int64>("id")
    private let type_name_en = Expression<String?>("name_en")
    private let type_name_vn = Expression<String?>("name_vn")
    
    // Table Vocabulary
    private let tblVocabulary = Table("vocabulary")
    private let vo_id = Expression<Int64>("id")
    private let vo_cat_id = Expression<Int64>("cat_id")
    private let vo_type_id = Expression<Int64?>("type_id")
    private let vo_en = Expression<String?>("name_en")
    private let vo_vn = Expression<String?>("name_vn")
    private let vo_pronunciation = Expression<String?>("pronunciation")
    private let vo_example = Expression<String?>("example")
    private let vo_image = Expression<String?>("image")
    private let vo_status = Expression<Bool?>("status")
    private let vo_created = Expression<String?>("created")
    
    // Table Report
    private let tblReport = Table("report")
    private let re_id = Expression<Int64>("id")
    private let re_total_word_true = Expression<Int?>("totalwordtrue")
    private let re_total_word = Expression<Int?>("totalword")
    private let re_total_add_word = Expression<Int?>("totaladdword")
    private let re_total_learned_word = Expression<Int?>("totallearnedword")
    private let re_total_phrase_true = Expression<Int?>("totalphrasetrue")
    private let re_total_phrase = Expression<Int?>("totalphrase")
    private let re_total_add_phrase = Expression<Int?>("totaladdphrase")
    private let re_total_learned_phrase = Expression<Int?>("totallearnedphrase")
    private let re_total_idioms_true = Expression<Int?>("totalidiomstrue")
    private let re_total_idioms = Expression<Int?>("totalidioms")
    private let re_total_add_idioms = Expression<Int?>("totaladdidioms")
    private let re_total_learned_idioms = Expression<Int?>("totallearnedidioms")
    private let re_created = Expression<String?>("created")
    
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/data.sqlite")
            print(path)
            createTableCategory()
            createTableTypeofWord()
            createTableVocabulary()
            createTableStatistical()
            
        } catch {
            db = nil
            print("Unable to open database. Error: \(error)")
        }
    }
    
    // MARK: *** Table Category
    func createTableCategory() {
        do {
            try db!.run(tblCategory.create(ifNotExists: true) { table in
                table.column(cat_id, primaryKey: true)
                table.column(cat_name_en)
                table.column(cat_name_vn)
            })
            if try db!.scalar(tblCategory.count) == 0 {
                addDataDemoTableCategory()
            }
        } catch {
            print("Unable to create table Category. Error: \(error)")
        }
    }
    
    func addDataDemoTableCategory() {
        do {
            try db!.run(tblCategory.insert(cat_name_en <- "Word", cat_name_vn <- "Từ"))
            try db!.run(tblCategory.insert(cat_name_en <- "Phrase", cat_name_vn <- "Cụm từ"))
            try db!.run(tblCategory.insert(cat_name_en <- "Idioms", cat_name_vn <- "Thành ngữ"))
        } catch {
            print("Cannot insert to database Category. Error: \(error)")
        }
    }
    
    func getAllCategory() -> [Category] {
        var categories = [Category]()
        
        do {
            for category in try db!.prepare(self.tblCategory) {
                let newCategory = Category(id: category[cat_id], name_en: category[cat_name_en]!, name_vn: category[cat_name_vn]!)
                categories.append(newCategory)
            }
        } catch {
            print("Cannot get list of Category. Error: \(error)")
        }
        
        return categories
    }
    
    // MARK: *** Table Type of Word
    func createTableTypeofWord() {
        do {
            try db!.run(tblTypeofWord.create(ifNotExists: true) { table in
                table.column(type_id, primaryKey: true)
                table.column(type_name_en)
                table.column(type_name_vn)
            })
            if try db!.scalar(tblTypeofWord.count) == 0 {
                addDataDemoTableTypeofWord()
            }
        } catch {
            print("Unable to create table Type of Word. Error: \(error)")
        }
    }
    
    func addDataDemoTableTypeofWord() {
        do {
            try db!.run(tblTypeofWord.insert(type_name_en <- "Noun", type_name_vn <- "Danh từ"))
            try db!.run(tblTypeofWord.insert(type_name_en <- "Pronoun", type_name_vn <- "Đại từ"))
            try db!.run(tblTypeofWord.insert(type_name_en <- "Verb", type_name_vn <- "Động từ"))
            try db!.run(tblTypeofWord.insert(type_name_en <- "Adverb", type_name_vn <- "Trạng từ"))
            try db!.run(tblTypeofWord.insert(type_name_en <- "Preposition", type_name_vn <- "Giới từ"))
        } catch {
            print("Cannot insert to database Type of Word. Error: \(error)")
        }
    }
    
    func getAllTypeofWord() -> [TypeofWord] {
        var typeofWords = [TypeofWord]()
        do {
            for typeofWord in try db!.prepare(self.tblTypeofWord) {
                let newType = TypeofWord(id: typeofWord[type_id], name_en: typeofWord[type_name_en]!, name_vn: typeofWord[type_name_vn]!)
                typeofWords.append(newType)
            }
        } catch {
            print("Cannot get list of Type of Word. Error: \(error)")
        }
        
        return typeofWords
    }
    
    func getTypeofWordByID(id: Int64) -> TypeofWord? {
        var typeofWord: TypeofWord?

        do {
            for type in try db!.prepare(self.tblTypeofWord.filter(type_id == id)) {
                typeofWord = TypeofWord(id: type[type_id], name_en: type[type_name_en]!, name_vn: type[type_name_vn]!)
            }
            
        } catch {
            print("Cannot get list of Type of Word by id. Error: \(error)")
        }
        
        return typeofWord
    }
    
    // MARK: *** Table Vocabulary
    func createTableVocabulary() {
        do {
            try db!.run(tblVocabulary.create(ifNotExists: true) { table in
                table.column(vo_id, primaryKey: true)
                table.column(vo_cat_id)
                table.column(vo_type_id)
                table.column(vo_en)
                table.column(vo_vn)
                table.column(vo_pronunciation)
                table.column(vo_example)
                table.column(vo_image)
                table.column(vo_status)
                table.column(vo_created)
            })
        } catch {
            print("Unable to create table Vocabulary. Error: \(error)")
        }
        
    }
    
    func addVocabulary(cat_id: Int64, type_id: Int64?, name_en: String, name_vn: String, pronunciation: String?, example: String?, image: String?, status: Bool, created: String) -> Int64? {
        do {
            let insert = tblVocabulary.insert(vo_cat_id <- cat_id, vo_type_id <- type_id, vo_en <- name_en, vo_vn <- name_vn, vo_pronunciation <- pronunciation, vo_example <- example, vo_image <- image, vo_status <- status, vo_created <- created)
            let id = try db!.run(insert)
            return id
        } catch {
            print("Cannot insert vocabulary to database")
            return nil
        }
    }
    
    func getAllVocabulary_Word(cat_id: Int64) -> [Vocabulary] {
        var vocabularys = [Vocabulary]()
        
        do {
            for vocabulary in try db!.prepare(self.tblVocabulary.filter(vo_cat_id == cat_id && vo_status == false)) {
                let newVo = Vocabulary(id: vocabulary[vo_id], cat_id: vocabulary[vo_cat_id], type_id: vocabulary[vo_type_id], name_en: vocabulary[vo_en]!, name_vn: vocabulary[vo_vn]!, pronunciation: vocabulary[vo_pronunciation], example: vocabulary[vo_example], image: vocabulary[vo_image], status: vocabulary[vo_status]!, created: vocabulary[vo_created]!)
                vocabularys.append(newVo)
            }
        } catch {
            print("Cannot get list of word in vocabulary. Error: \(error)")
        }
        
        return vocabularys
    }
    
    func updateVocabularybyID(newVocabulary: Vocabulary) -> Bool {
        let tblfilterVocabulary = tblVocabulary.filter(vo_id == newVocabulary.id)
        do {
            let update = tblfilterVocabulary.update([
                    vo_cat_id <- newVocabulary.cat_id,
                    vo_type_id <- newVocabulary.type_id,
                    vo_en <- newVocabulary.name_en,
                    vo_vn <- newVocabulary.name_vn,
                    vo_pronunciation <- newVocabulary.pronunciation,
                    vo_example <- newVocabulary.example,
                    vo_image <- newVocabulary.image,
                    vo_status <- newVocabulary.status
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("update fail. Error: \(error)")
        }
        return false
    }
    
    func updateVocabularyLearn(id: Int64, status: Bool) -> Bool {
        let tblfilterVocabulary = tblVocabulary.filter(vo_id == id)
        do {
            let update = tblfilterVocabulary.update([
                    vo_status <- status
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("update fail. Error: \(error)")
        }
        return false
    }
    
    func deleteVocabulary(id: Int64) -> Bool {
        do {
            let tblFilterVocabulary = tblVocabulary.filter(vo_id == id)
            try db!.run(tblFilterVocabulary.delete())
            return true
        } catch {
            print("Delete failed. Error: \(error)")
        }
        
        return false
    }
    
    
    func getVocabularyfoTest(startDate: String, endDate: String, status: Bool, cat_id: Int64) -> [Vocabulary] {
        var vocabularys = [Vocabulary]()
        
        do {
            for vocabulary in try db!.prepare(tblVocabulary.filter(vo_created >= startDate && vo_created <= endDate && vo_status == status && vo_cat_id == cat_id)) {
                let newVo = Vocabulary(id: vocabulary[vo_id], cat_id: vocabulary[vo_cat_id], type_id: vocabulary[vo_type_id], name_en: vocabulary[vo_en]!, name_vn: vocabulary[vo_vn]!, pronunciation: vocabulary[vo_pronunciation], example: vocabulary[vo_example], image: vocabulary[vo_image], status: vocabulary[vo_status]!, created: vocabulary[vo_created]!)
                vocabularys.append(newVo)
            }
        } catch {
            print("loi cmnr kaka. Error: \(error)")
        }
        
        return vocabularys
    }
    
    func getAllVocabulary() -> [Vocabulary] {
        var vocabularys = [Vocabulary]()
        
        do {
            for vocabulary in try db!.prepare(self.tblVocabulary) {
                let newVo = Vocabulary(id: vocabulary[vo_id], cat_id: vocabulary[vo_cat_id], type_id: vocabulary[vo_type_id], name_en: vocabulary[vo_en]!, name_vn: vocabulary[vo_vn]!, pronunciation: vocabulary[vo_pronunciation], example: vocabulary[vo_example], image: vocabulary[vo_image], status: vocabulary[vo_status]!, created: vocabulary[vo_created]!)
                vocabularys.append(newVo)
            }
        } catch {
            print("Cannot get list of word in vocabulary. Error: \(error)")
        }
        
        return vocabularys
    }
    
    func getAllVocabularybyCatID(cat_id: Int64) -> [Vocabulary] {
        var vocabularys = [Vocabulary]()
        
        do {
            for vocabulary in try db!.prepare(self.tblVocabulary.filter(vo_cat_id == cat_id)) {
                let newVo = Vocabulary(id: vocabulary[vo_id], cat_id: vocabulary[vo_cat_id], type_id: vocabulary[vo_type_id], name_en: vocabulary[vo_en]!, name_vn: vocabulary[vo_vn]!, pronunciation: vocabulary[vo_pronunciation], example: vocabulary[vo_example], image: vocabulary[vo_image], status: vocabulary[vo_status]!, created: vocabulary[vo_created]!)
                vocabularys.append(newVo)
            }
        } catch {
            print("Cannot get list of word in vocabulary. Error: \(error)")
        }
        
        return vocabularys
    }
    
    func addDataDemo() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateCreated = dateFormatter.string(from: date)
        
        do {
            // Word
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "scorpion",
                vo_vn <- "con bọ cạp",
                vo_pronunciation <- "/ˈskɔːr.pi.ən/",
                vo_example <- "You could be killed by a scorpion if it stings you.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "cockroach",
                vo_vn <- "con gián",
                vo_pronunciation <- "/ˈkɑːkroʊtʃ/",
                vo_example <- "Cockroach usually lives in wet dirty corner.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "cricket",
                vo_vn <- "con dế",
                vo_pronunciation <- "/ˈkrɪkɪt/",
                vo_example <- "In the summer night, cricket makes a song with beautiful sound.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "Universe",
                vo_vn <- "Vũ trụ",
                vo_pronunciation <- "/ˈjuːnɪvɜːrs/",
                vo_example <- "We have advanced greatly in our knowledge of the universe.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "circle",
                vo_vn <- "Hình tròn",
                vo_pronunciation <- "/ˈsɜːkl/",
                vo_example <- "It is so easy to draw a circle.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "square",
                vo_vn <- "Hình vuông",
                vo_pronunciation <- "/skweə(r)/",
                vo_example <- "A square has four equal sides.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "rectangle",
                vo_vn <- "Hình chữ nhật",
                vo_pronunciation <- "/ˈrektæŋɡl/",
                vo_example <- "If we lengthen two opposite sides of a square, we will have a rectangle.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "triangle",
                vo_vn <- "Hình tam giác",
                vo_pronunciation <- "/ˈtraɪæŋɡl/",
                vo_example <- "Because this shape has three angles, we call it a triangle.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "Galaxy",
                vo_vn <- "thiên hà",
                vo_pronunciation <- "/ˈɡæləksi/",
                vo_example <- "How many stars are there in our galaxy.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 1,
                vo_type_id <- 1,
                vo_en <- "butterfly",
                vo_vn <- "con bươm bướm",
                vo_pronunciation <- "/ˈbʌtərflaɪ/",
                vo_example <- "The colorful wings of the butterfly is impressive.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            
            // Phrase
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Give a hand",
                vo_vn <- "Giúp đỡ, trợ giúp",
                vo_pronunciation <- nil,
                vo_example <- "Can I give you a hand with those bags?",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Give thought",
                vo_vn <- "Suy nghĩ, cân nhắc về điều gì đó",
                vo_pronunciation <- nil,
                vo_example <- "I'll give what you said some thought and get back to you.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Give evidence",
                vo_vn <- "Đưa ra bằng chứng trước toà hoặc cuộc tra hỏi",
                vo_pronunciation <- nil,
                vo_example <- "Has she agreed to give evidence at the trial?",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Heavy smoker",
                vo_vn <- "Người nghiện thuốc, hút nhiều thuốc lá",
                vo_pronunciation <- nil,
                vo_example <- "My uncle's a heavy smoker. He smokes forty a day!",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Heavy drinker",
                vo_vn <- "Người uống rất nhiều rượu",
                vo_pronunciation <- nil,
                vo_example <- "My brother's a heavy drinker, but I only have one or two beers.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Have a chat",
                vo_vn <- "Nói chuyện vui vẻ với ai đó",
                vo_pronunciation <- nil,
                vo_example <- "I always enjoy having a chat with Mark.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Have a look at",
                vo_vn <- "Nhìn thứ gì đó",
                vo_pronunciation <- nil,
                vo_example <- "Can I have a look at your wedding photos?",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Give birth",
                vo_vn <- "Sinh con, sinh nở",
                vo_pronunciation <- nil,
                vo_example <- "Joanna gave birth to a healthy baby boy.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 2,
                vo_type_id <- nil,
                vo_en <- "Get tired of",
                vo_vn <- "Buồn chán, mệt mỏi vì một thứ gì đó",
                vo_pronunciation <- nil,
                vo_example <- "We got tired of playing computer games, so we went for a swim.",
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            
            // Idioms
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 3,
                vo_type_id <- nil,
                vo_en <- "Going places",
                vo_vn <- "Có đủ tài năng cho một tương lai thành công",
                vo_pronunciation <- nil,
                vo_example <- nil,
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 3,
                vo_type_id <- nil,
                vo_en <- "Deep down",
                vo_vn <- "Mô tả cảm xúc sâu kín của ai đó, cái ai đó yêu thích trong thâm tâm",
                vo_pronunciation <- nil,
                vo_example <- nil,
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 3,
                vo_type_id <- nil,
                vo_en <- "Bee in one's bonnet (about)",
                vo_vn <- "Suy nghĩ rất nhiều về một việc nào đó",
                vo_pronunciation <- nil,
                vo_example <- nil,
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 3,
                vo_type_id <- nil,
                vo_en <- "Cut to the quick",
                vo_vn <- "Làm tổn thương sâu sắc người khác, xúc phạm người khác",
                vo_pronunciation <- nil,
                vo_example <- nil,
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 3,
                vo_type_id <- nil,
                vo_en <- "Cork up something",
                vo_vn <- "Khó thể hiện cảm xúc, kìm nén cảm xúc",
                vo_pronunciation <- nil,
                vo_example <- nil,
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 3,
                vo_type_id <- nil,
                vo_en <- "Sink your teeth into",
                vo_vn <- "Bỏ rất nhiều nỗ lực và tâm sức vào một việc nào đó",
                vo_pronunciation <- nil,
                vo_example <- nil,
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
            try db!.run(tblVocabulary.insert(
                vo_cat_id <- 3,
                vo_type_id <- nil,
                vo_en <- "Carry the torch for",
                vo_vn <- "Yêu thương ai đó mãnh liệt cho dù người đó không bao giờ thuộc về bạn",
                vo_pronunciation <- nil,
                vo_example <- nil,
                vo_image <- nil,
                vo_status <- false,
                vo_created <- dateCreated
            ))
        } catch {
            print("Cannot insert to database Vocabulary. Error: \(error)")
        }

    }
    
    // MARK: *** Table Report
    func createTableStatistical() {
        do {
            try db!.run(tblReport.create(ifNotExists: true) { table in
                table.column(re_id, primaryKey: true)
                table.column(re_total_word_true)
                table.column(re_total_word)
                table.column(re_total_add_word)
                table.column(re_total_learned_word)
                table.column(re_total_phrase_true)
                table.column(re_total_phrase)
                table.column(re_total_add_phrase)
                table.column(re_total_learned_phrase)
                table.column(re_total_idioms_true)
                table.column(re_total_idioms)
                table.column(re_total_add_idioms)
                table.column(re_total_learned_idioms)
                table.column(re_created)
            })
        } catch {
            print("Unable to create table Vocabulary. Error: \(error)")
        }
    }
    
    func addOrUpdateReport(total_word_true: Int, total_word: Int, total_add_word: Int, total_learned_word: Int, total_phrase_true: Int, total_phrase: Int, total_add_phrase: Int, total_learned_phrase: Int, total_idioms_true: Int, total_idioms: Int, total_add_idioms: Int, total_learned_idioms: Int, created: String) -> Bool {
        
        do {
            try db!.transaction {
                
                let tblfilterReport = self.tblReport.filter(self.re_created == created)
                
                let update = tblfilterReport.update([
                    self.re_total_word_true <- self.re_total_word_true + total_word_true,
                    self.re_total_word <- self.re_total_word + total_word,
                    self.re_total_add_word <- self.re_total_add_word + total_add_word,
                    self.re_total_learned_word <- self.re_total_learned_word + total_learned_word,
                    self.re_total_phrase_true <- self.re_total_phrase_true + total_phrase_true,
                    self.re_total_phrase <- self.re_total_phrase + total_phrase,
                    self.re_total_add_phrase <- self.re_total_add_phrase + total_add_phrase,
                    self.re_total_learned_phrase <- self.re_total_learned_phrase + total_learned_phrase,
                    self.re_total_idioms_true <- self.re_total_idioms_true + total_idioms_true,
                    self.re_total_idioms <- self.re_total_idioms + total_idioms,
                    self.re_total_add_idioms <- self.re_total_add_idioms + total_add_idioms,
                    self.re_total_learned_idioms <- self.re_total_learned_idioms + total_learned_idioms
                ])
                // update
                if try self.db!.run(update) > 0 {
                    print("update successfully")
                } else {
                    // add
                    let insert = self.tblReport.insert(
                        self.re_total_word_true <- total_word_true,
                        self.re_total_word <- total_word,
                        self.re_total_add_word <- total_add_word,
                        self.re_total_learned_word <- total_learned_word,
                        self.re_total_phrase_true <- total_phrase_true,
                        self.re_total_phrase <- total_phrase,
                        self.re_total_add_phrase <- total_add_phrase,
                        self.re_total_learned_phrase <- total_learned_phrase,
                        self.re_total_idioms_true <- total_idioms_true,
                        self.re_total_idioms <- total_idioms,
                        self.re_total_add_idioms <- total_add_idioms,
                        self.re_total_learned_idioms <- total_learned_idioms,
                        self.re_created <- created
                    )
                    
                    let rowid = try self.db!.run(insert)
                    print("inserted id: \(rowid)")
                }
            }
            
            return true
        } catch {
            print("Cannot add or update report. Error: \(error)")
        }
        
        return false
    }
    
    func getReportByTime(startDate: String, endDate: String) -> [Report] {
        var reports = [Report]()
        
        do {
            for report in try db!.prepare(tblReport.filter(re_created >= startDate && re_created <= endDate)) {
                let newReport = Report(id: report[re_id], totalwordtrue: report[re_total_word_true]!, totalword: report[re_total_word]!, totaladdword: report[re_total_add_word]!, totallearnedword: report[re_total_learned_word]!, totalphrasetrue: report[re_total_phrase_true]!, totalphrase: report[re_total_phrase]!, totaladdphrase: report[re_total_add_phrase]!, totallearnedphrase: report[re_total_learned_phrase]!, totalidiomstrue: report[re_total_idioms_true]!, totalidioms: report[re_total_idioms]!, totaladdidioms: report[re_total_add_idioms]!, totallearnedidioms: report[re_total_learned_idioms]!, created: report[re_created]!)
                
                reports.append(newReport)
            }
        } catch {
            print("Cannot get report by time. Error: \(error)")
        }
        
        return reports
    }
}
