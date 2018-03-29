//
//  AppServices.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import Firebase



// MARK: - UIImageView Extension
extension UIImageView {
    func GetImageForURL(ImageURL imgURL:String!) {
        // set the default image while we wait
        image = #imageLiteral(resourceName: "placeholderImage")
        
        _ = AppServices.GetImageForURL(ImageURL: imgURL, Completion: { [weak self] (img)  in
            self?.image = img
        })
    }
}



class AppServices {
    
    private static var db = Firestore.firestore()
    private static var storage = Storage.storage()
    
    // Simple Image Cached
    private static var imageCache:Dictionary<String,Data> = Dictionary<String,Data>()
    
    static func GetPokemon (Completion completion:@escaping(Array<PokemonModel>) -> Void) {
        db.collection("pokemon").getDocuments { (querySnapshot, error) in
            var pokemon = Array<PokemonModel>()
            
            if (error == nil) {
                pokemon = mapDataToModel(Documents: (querySnapshot?.documents)!)
            } else {
                print("Document data: \(error?.localizedDescription)")
            }
            
            completion(pokemon)
        }
    }
    
    private static func mapDataToModel (Documents docs:Array<DocumentSnapshot>) -> Array<PokemonModel> {
        var pokemon = Array<PokemonModel>()
        
        if (docs.count > 0) {
            let pokemonDoc = docs[0]
            if let pokemonData:Dictionary<String,Any> = pokemonDoc.data() {
                for key in pokemonData.keys {
                    if let currPokemonData = pokemonData[key] as? Dictionary<String,Any> {
                        var fastMoves:Array<PokemonFastMoveModel>? = nil
                        if let fastMovesData = currPokemonData["fastMoves"] as? Array<Dictionary<String,Any>> {
                            fastMoves = mapFastMoves(fastMovesData)
                        }
                        
                        var chargeMoves:Array<PokemonChargeMoveModel>? = nil
                        if let chargeMovesData = currPokemonData["chargeMoves"] as? Array<Dictionary<String,Any>> {
                            chargeMoves = mapChargeMoves(chargeMovesData)
                        }
                        
                        if let name = currPokemonData["name"] as? String, let types = currPokemonData["types"] as? Array<String>,
                            let pokemonNumber = currPokemonData["pokemonNumber"] as? Int, let attack = currPokemonData["attack"] as? Int,
                            let defense = currPokemonData["defense"] as? Int, let stamina = currPokemonData["stamina"] as? Int,
                            fastMoves != nil, chargeMoves != nil, let generation = currPokemonData["generation"] as? Int,
                            let legendary = currPokemonData["legendary"] as? Bool {
                            let currPokemon = PokemonModel(Name: name, Types: types, PokemonNumber: pokemonNumber, Atack: attack,
                                                           Defense: defense, Stamina: stamina, FastMoves: fastMoves!, ChargeMoves: chargeMoves!, Generation: generation, Legendary: legendary)
                            pokemon.append(currPokemon)
                        }
                    }
                }
            }
        }
        
        return pokemon
    }
    
    private static func mapFastMoves(_ moves:Array<Dictionary<String,Any>>) -> Array<PokemonFastMoveModel> {
        var mappedMoves = Array<PokemonFastMoveModel>()
        
        for currMove in moves {
            if let name = currMove["name"] as? String, let typeStr = currMove["type"] as? String,
                let damage = currMove["damage"] as? Int, let duration = currMove["duration"] as? Double,
                let energyGain = currMove["energyGain"] as? Int, let active = currMove["active"] as? Bool {
                if let type = PokemonType(rawValue: typeStr) {
                    let move = PokemonFastMoveModel(Name: name, Type: type, Damage: damage, Duration: duration,
                                                        EnergyGain: energyGain, Active: active)
                    mappedMoves.append(move)
                }
            }
        }
        
        return mappedMoves
    }
    
    private static func mapChargeMoves(_ moves:Array<Dictionary<String,Any>>) -> Array<PokemonChargeMoveModel> {
        var mappedMoves = Array<PokemonChargeMoveModel>()
        
        for currMove in moves {
            if let name = currMove["name"] as? String, let typeStr = currMove["type"] as? String,
                let damage = currMove["damage"] as? Int, let duration = currMove["duration"] as? Double,
                let energyCost = currMove["energyCost"] as? Int, let active = currMove["active"] as? Bool {
                if let type = PokemonType(rawValue: typeStr) {
                    let move = PokemonChargeMoveModel(Name: name, Type: type, Damage: damage, Duration: duration,
                                                        EnergyCost: energyCost, Active: active)
                    mappedMoves.append(move)
                }
            }
        }
        
        return mappedMoves
    }
    
    
    /*
    static func GetActivityForName (ActivityName name:String!, Completion completion:@escaping(ActivityModelProtocol?) -> Void) {
        db.collection(name).getDocuments { (querySnapshot, error) in
            var activity:ActivityModelProtocol?
            
            if (error == nil) {
                activity = mapActivityToModel(Documents: (querySnapshot?.documents)!)
            } else {
                print("Document data: \(error?.localizedDescription)")
            }
            
            completion(activity)
        }
    }
    
    private static func mapActivityToModel (Documents docs:Array<DocumentSnapshot>) -> ActivityModelProtocol? {
        var activity:ActivityModelProtocol? = nil
        
        if (docs.count > 0) {
            let activityDoc = docs[0]
            let currData:Dictionary<String,Any> = activityDoc.data()
            
            if let typeVal = currData["type"] {
                switch (typeVal as! String) {
                case ActivityType.Quiz.AsString():
                    let questions = populateQuestionData(Documents: docs)
                    if let introVal = currData["intro"], let imageURL = currData["imageURL"], let headerVal = currData["header"], questions.count > 0 {
                        activity = QuizActivity(ImageURL: imageURL as! String, Header: headerVal as! String,
                                                Intro: introVal as! String, Questions: questions)
                    }
                    break
                case ActivityType.RevealCards.AsString():
                    if let cardsData = currData["cards"] as? Array<Dictionary<String,Any>> {
                        let cards = populateRevealCardData(CardsData: cardsData)
                        if cards.count > 0, let imageURL = currData["imageURL"], let headerVal = currData["header"], let introVal = currData["intro"] {
                            activity = RevealCardsActivity(ImageURL: imageURL as! String, Header: headerVal as! String,
                                                           Intro: introVal as! String, Cards: cards)
                        }
                    }
                    break
                case ActivityType.InfoBubbles.AsString():
                    if let bubbleData = currData["bubbles"] as? Array<Dictionary<String,Any>> {
                        let bubbles = populateInfoBubblesData(BubbleData: bubbleData)
                        if bubbles.count > 0, let iconIndex = currData["iconIndex"], let headerVal = currData["title"], let introVal = currData["description"],
                            let backgroundURL = currData["backgroundURL"], let foregroundURL = currData["foregroundURL"] {
                            activity = InfoBubblesActivity(Header: headerVal as! String, Intro: introVal as! String, IconIndex: iconIndex as! Int,
                                                           BackgroundURL: backgroundURL as! String, ForegroundURL: foregroundURL as! String, BubbleData: bubbles)
                        }
                    }
                    break
                case ActivityType.Article.AsString():
                    //case ActivityType.ArticleLong.AsString():
                    if let paragraphData = currData["paragraphs"] as? Array<Dictionary<String,Any>> {
                        let paragraphs = populateArticleParagraphData(ParagraphData: paragraphData)
                        
                        var completionQues:QuestionViewModelProtocol? = nil
                        if let cQues = mapQuestionToModel(QuestionData: currData["completionQuestion"] as! Dictionary<String,Any>) {
                            completionQues = cQues
                        }
                        
                        var readingLevel:String? = nil
                        if let rLevel = currData["readingLevel"] {
                            readingLevel = rLevel as? String
                        }
                        
                        var copyrightHolder:String? = nil
                        if let cHolder = currData["copyrightHolder"] {
                            copyrightHolder = cHolder as? String
                        }
                        
                        if paragraphs.count > 0, let imageURL = currData["imageURL"], let headerVal = currData["title"], let introVal = currData["description"] {
                            activity = ArticleLongActivity(ImageURL: imageURL as! String, Header: headerVal as! String, Intro: introVal as! String, ArticleParagraphs: paragraphs,
                                                           CompletionQuestion: completionQues, ReadingLevel: readingLevel, CopyrightHolder: copyrightHolder)
                        }
                    }
                    break
                case ActivityType.Recipe.AsString():
                    if let ingredientData = currData["ingredients"] as? Array<String>, let instructionData = currData["instructions"] as? Array<String>,
                        let nutritionInfoData = currData["nutritionalInfo"] as? Array<Dictionary<String,String>> , let nutritionMineralData = currData["nutritionalMineral"] as? Array<Dictionary<String,String>> {
                        let activityRecipeItems:Dictionary<RecipeItemType,Array<RecipeItemViewModel>> = [RecipeItemType.Ingredients : populateRecipeItemData(ItemData: ingredientData),
                                                                                                         RecipeItemType.Instructions : populateRecipeItemData(ItemData: instructionData)]
                        
                        let activityRecipeNutritionItems:Dictionary<RecipeNutritionItemType,Array<RecipeNutritionItemViewModel>> = [RecipeNutritionItemType.DefaultInfo : populateRecipeNutritionItemData(NutritionItemData: nutritionInfoData),
                                                                                                                                    RecipeNutritionItemType.Minerals : populateRecipeNutritionItemData(NutritionItemData: nutritionMineralData)]
                        
                        if let imageURL = currData["imageURL"] as? String, let headerVal = currData["title"] as? String, let introVal = currData["description"] as? String, let calVal = currData["calories"] as? String,
                            let fatVal = currData["fat"] as? String, let cookTimeVal = currData["duration"] as? String, let servingAmountVal = currData["size"] as? String, let sizeVal = currData["servingSize"] as? String,
                            let copyright = currData["legal_footer"] as? String, let tipVal = currData["tip"] as? String {
                            activity = RecipeActivity(ImageURL: imageURL, Header: headerVal, CookTime: cookTimeVal, ServingAmount: servingAmountVal, Calories: calVal, Fat: fatVal, Intro: introVal,
                                                      Recipe: activityRecipeItems, ServingSize: sizeVal, NutritionLabel:activityRecipeNutritionItems, CopyrightHolder: copyright, Tip: tipVal)
                        }
                    }
                    break
                default:
                    print("Not matching activity model for Type: \(typeVal)")
                    break
                }
                
                if (activity != nil) {
                    if let program = currData["program"] as? String  {
                        activity?.ProgramName = program
                    }
                    if let subTopic = currData["subtopic"] as? String  {
                        activity?.SubTopicName = subTopic
                    }
                }
            }
        }
        
        return activity
    }
    
    
    
    // MARK: - Handle Data Models
    
    private static func populateQuestionData (Documents docs:Array<DocumentSnapshot>) -> Array<QuestionViewModelProtocol> {
        var activityQuestions:Array<QuestionViewModelProtocol> = []
        
        // TODO: firbase web GUI doesn't currently support the needed structure so the questions are not in an array as expected
        
        if (docs.count > 0) {
            let activityDoc = docs[0]
            
            let currData:Dictionary<String,Any> = activityDoc.data()
            for key in currData.keys {
                if (key.starts(with: "question")) {
                    let questionVal:Dictionary<String,Any> = currData[key] as! Dictionary<String,Any>
                    
                    if let questionViewModel = mapQuestionToModel(QuestionData: questionVal) {
                        activityQuestions.append(questionViewModel)
                    }
                }
            }
        }
        
        return activityQuestions
    }
    
    private static func mapQuestionToModel (QuestionData questionVal:Dictionary<String,Any>) -> QuestionViewModelProtocol? {
        var questionViewModel:QuestionViewModelProtocol? = nil
        
        if let typeVal = questionVal["type"] {
            switch (typeVal as! String) {
            case ModelType.TrueFalse.AsString():
                if let quesVal = questionVal["question"], let answer = questionVal["answer"],
                    let explanation = questionVal["explanation"], let imageURL = questionVal["imageURL"] {
                    questionViewModel = QuestionTrueFalse(Question: (quesVal as! String), CorrectAnswer: (answer as! Bool), RelatedImageURL: (imageURL as! String), AnswerExplanation: (explanation as! String))
                }
                break
            case ModelType.TextMultiChoice.AsString():
                if let quesVal = questionVal["question"], let answers = questionVal["answers"],
                    let answerIndex = questionVal["answerIndex"], let explanation = questionVal["explanation"] {
                    questionViewModel = QuestionTextMultiChoice(Question: (quesVal as! String), Answers: (answers as! Array<String>), CorrectAnswerIndex: (answerIndex as! Int), AnswerExplanation: (explanation as! String))
                }
                break
            case ModelType.SingleImageTextMultiChoice.AsString():
                // TODO: handle accessibility tag
                if let imageURL = questionVal["imageURL"], let quesVal = questionVal["question"], let answers = questionVal["answers"],
                    let answerIndex = questionVal["answerIndex"], let explanation = questionVal["explanation"] {
                    questionViewModel = QuestionSingleImageTextMultiChoice(ImageURL: (imageURL as! String), ImageAccessibilityTag: "TODO", Question: (quesVal as! String),
                                                                           Answers: (answers as! Array<String>), CorrectAnswerIndex: (answerIndex as! Int), AnswerExplanation: (explanation as! String))
                }
                break
            default:
                print("Not matching question model for Type: \(typeVal)")
                break
            }
        } else {
            print("Type not found")
        }
        
        return questionViewModel
    }
    */
    
    
    
    // MARK: - Image Related Methods
    
    static func GetImageForURL(ImageURL imgURL:String!, Completion completion:@escaping(UIImage?) -> Void) {
        // check if the image data already exists in the cache
        if let imgCacheData = imageCache[imgURL] {
            let img = UIImage(data: imgCacheData)
            
            completion(img)
        } else {
            // Create a reference with an initial file path and name
            let imagePathRefef = storage.reference(withPath: imgURL)
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imagePathRefef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                var img:UIImage? = nil
                
                if let error = error {
                    // error occurred!
                    // TODO: handle
                    print("GetImageForURL error: \(error)")
                } else {
                    // image data was returned
                    img = UIImage(data: data!)
                    
                    // add the data to our cache
                    imageCache[imgURL] = data!
                }
                
                completion(img)
            }
        }
    }
    
    static func EmptyImageCache() {
        // TODO: add logic to handle the option only clearing image data that hasn't been used in a while
        
        imageCache.removeAll()
    }
}
