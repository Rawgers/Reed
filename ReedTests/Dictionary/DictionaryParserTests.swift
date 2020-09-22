//
//  ReedTests.swift
//  ReedTests
//
//  Created by Roger Luo on 9/9/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import CoreData
import XCTest
@testable import Reed


class DictionaryParserTest: XCTestCase {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    var mockParser: DictionaryParser!
    var mockContext: NSManagedObjectContext!
    var mockContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        mockContainer = createMockPersistentContainer(model: managedObjectModel)
        let mockStorageManager = DictionaryStorageManager(container: mockContainer)
        mockParser = DictionaryParser(storageManager: mockStorageManager)
        mockContext = mockParser.context
    }
    
    override func tearDown() {
        mockParser.storageManager.flushAll()
        super.tearDown()
    }
    
    func testReadInDictionaryData() {
        XCTAssertNotNil(try? mockParser.readInDictionaryData())
    }
    
    /// Test most basic entry with one <reb> and one <sense> tag.
    func testBasicEntry() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1077530"
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "チェッカーズ"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "checkers"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1077530,
            readings: [
                ExpectedReading(reading: "チェッカーズ"),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["checkers"]
                )
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <keb> tags are correctly parsed.
    func testEntryWithKeb() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1000100"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "ＡＢＣ順"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "エービーシーじゅん"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "alphabetical order"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1000100,
            terms: [
                ExpectedTerm(term: "ＡＢＣ順")
            ],
            readings: [
                ExpectedReading(
                    reading: "エービーシーじゅん",
                    terms: ["ＡＢＣ順"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["alphabetical order"]
                )
            ]
        )

        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <ke_inf> tags are correctly parsed.
    func testKinf() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1174360"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "盈虧"
                            ],
                            "ke_inf": [
                                "&oK;"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "えいき"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "waxing and waning",
                                "phases of moon"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1174360,
            terms: [
                ExpectedTerm(
                    term: "盈虧",
                    unusualInfo: ["&oK;"]
                )
            ],
            readings: [
                ExpectedReading(
                    reading: "えいき",
                    terms: ["盈虧"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "waxing and waning",
                        "phases of moon"
                    ]
                )
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <ke_pri> tags are correctly parsed.
    func testKpri() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1173570"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "営利"
                            ],
                            "ke_pri": [
                                "ichi1",
                                "news1",
                                "nf14"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "えいり"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "money-making",
                                "commercialized",
                                "commercialised"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        let expected = ExpectedEntry(
            id: 1173570,
            terms: [
                ExpectedTerm(
                    term: "営利",
                    frequencyPriorities: [
                        "ichi1",
                        "news1",
                        "nf14"
                    ]
                ),
            ],
            readings: [
                ExpectedReading(
                    reading: "えいり",
                    terms: ["営利"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "money-making",
                        "commercialized",
                        "commercialised"
                    ]
                )
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
        
    }

    /// Test <re_restr> tags are correctly parsed.
    func testParseRestr() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1099490"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "発条"
                            ],
                        },
                        {
                            "keb": [
                                "撥条"
                            ]
                        },
                        {
                            "keb": [
                                "弾機"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "ばね"
                            ],
                        },
                        {
                            "reb": [
                                "ぜんまい"
                            ],
                            "re_restr": [
                                "発条",
                                "撥条"
                            ]
                        },
                        {
                            "reb": [
                                "はつじょう"
                            ],
                            "re_restr": [
                                "発条",
                                "撥条"
                            ]
                        },
                        {
                            "reb": [
                                "だんき"
                            ],
                            "re_restr": [
                                "弾機"
                            ]
                        },
                        {
                            "reb": [
                                "バネ"
                            ],
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "spring (e.g. coil, leaf)",
                                "mainspring",
                                "power spring"
                            ]
                        }
                    ]
                },
            ]
            """
        )

        let expected = ExpectedEntry(
            id: 1099490,
            terms: [
                ExpectedTerm(term: "発条"),
                ExpectedTerm(term: "撥条"),
                ExpectedTerm(term: "弾機"),
            ],
            readings: [
                ExpectedReading(
                    reading: "ばね",
                    terms: ["発条", "撥条", "弾機"]
                ),
                ExpectedReading(
                    reading: "ぜんまい",
                    terms: ["発条", "撥条"]
                ),
                ExpectedReading(
                    reading: "はつじょう",
                    terms: ["発条", "撥条"]
                ),
                ExpectedReading(
                    reading: "だんき",
                    terms: ["弾機"]
                ),
                ExpectedReading(
                    reading: "バネ",
                    terms: ["発条", "撥条", "弾機"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "spring (e.g. coil, leaf)",
                        "mainspring",
                        "power spring"
                    ]
                ),
            ]
        )

        testParse(mockParser: mockParser, testData: testData, expected: expected)
    }
    
    /// Test <re_inf> tags are correctly parsed.
    func testRinf() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1605210"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "土竜"
                            ]
                        },
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "むぐら"
                            ],
                            "re_inf": [
                                "&gikun;",
                                "&ok;"
                            ]
                        },
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "mole (Talpidae spp., esp. the small Japanese mole, Mogera imaizumii)"
                            ]
                        }
                    ]
                }
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1605210,
            terms: [
                ExpectedTerm(
                    term: "土竜"
                ),
            ],
            readings: [
                ExpectedReading(
                    reading: "むぐら",
                    terms: ["土竜"],
                    unusualInfo: [
                        "&gikun;",
                        "&ok;"
                    ]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "mole (Talpidae spp., esp. the small Japanese mole, Mogera imaizumii)"
                    ]
                ),
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <re_pri> tags are correctly parsed.
    func testRpri() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1173570"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "営利"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "えいり"
                            ],
                            "re_pri": [
                                "ichi1",
                                "news1",
                                "nf14"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "money-making",
                                "commercialized",
                                "commercialised"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1173570,
            terms: [
                ExpectedTerm(
                    term: "営利"
                ),
            ],
            readings: [
                ExpectedReading(
                    reading: "えいり",
                    terms: ["営利"],
                    frequencyPriorities: [
                        "ichi1",
                        "news1",
                        "nf14"
                    ]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "money-making",
                        "commercialized",
                        "commercialised"
                    ]
                ),
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }

    /// Test <gloss> tag with `g_type` attribute is correctly parsed.
    func testGtype() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "2073170"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "框"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "かまち"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "door frame",
                                "window frame",
                                {
                                    "_": "frame sections of the door or window that provide most of its structural integrity",
                                    "$": {
                                        "g_type": "expl"
                                    }
                                }
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 2073170,
            terms: [
                ExpectedTerm(term: "框"),
            ],
            readings: [
                ExpectedReading(
                    reading: "かまち",
                    terms: ["框"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "door frame",
                        "window frame",
                        "frame sections of the door or window that provide most of its structural integrity"
                    ]
                ),
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <stagk> and <stagr> tags are correctly parsed.
    func testStagkAndStagr() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1171680"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "羽"
                            ],
                        },
                        {
                            "keb": [
                                "羽根"
                            ],
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "はね"
                            ],
                        },
                    ],
                    "sense": [
                        {
                            "gloss": [
                                "wing"
                            ]
                        },
                        {
                            "stagr": [
                                "はね"
                            ],
                            "gloss": [
                                "blade (of a fan, propeller, etc.)"
                            ]
                        },
                        {
                            "stagk": [
                                "羽根"
                            ],
                            "gloss": [
                                "shuttlecock (in hanetsuki)"
                            ]
                        },
                    ]
                },
            ]
            """
        )

        let expected = ExpectedEntry(
            id: 1171680,
            terms: [
                ExpectedTerm(term: "羽"),
                ExpectedTerm(term: "羽根"),
            ],
            readings: [
                ExpectedReading(
                    reading: "はね",
                    terms: ["羽", "羽根"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["wing"]
                ),
                ExpectedDefinition(
                    glosses: ["blade (of a fan, propeller, etc.)"],
                    specificLexemes: ["はね"]
                ),
                ExpectedDefinition(
                    glosses: ["shuttlecock (in hanetsuki)"],
                    specificLexemes: ["羽根"]
                ),
            ]
        )

        testParse(mockParser: mockParser, testData: testData, expected: expected)
    }

    /// Test <pos> correctly carries over multiple <sense> and is overridden by new <pos>.
    func testPos() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1172660"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "運ぶ"
                            ],
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "はこぶ"
                            ],
                        }
                    ],
                    "sense": [
                        {
                            "pos": [
                                "&v5b;",
                                "&vt;"
                            ],
                            "gloss": [
                                "to carry",
                                "to transport",
                                "to move",
                                "to convey"
                            ]
                        },
                        {
                            "gloss": [
                                "to wield (a tool, etc.)",
                                "to use"
                            ]
                        },
                        {
                            "pos": [
                                "&v5b;"
                            ],
                            "gloss": [
                                "to come",
                                "to go"
                            ]
                        },
                        {
                            "pos": [
                                "&v5b;",
                                "&vi;"
                            ],
                            "gloss": [
                                "to go (well, etc.)",
                                "to proceed",
                                "to progress"
                            ]
                        }
                    ]
                },
            ]
            """
        )

        let expected = ExpectedEntry(
            id: 1172660,
            terms: [
                ExpectedTerm(term: "運ぶ"),
            ],
            readings: [
                ExpectedReading(
                    reading: "はこぶ",
                    terms: ["運ぶ"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "to carry",
                        "to transport",
                        "to move",
                        "to convey",
                    ],
                    partsOfSpeech: ["&v5b;", "&vt;"]
                ),
                ExpectedDefinition(
                    glosses: [
                        "to wield (a tool, etc.)",
                        "to use",
                    ],
                    partsOfSpeech: ["&v5b;", "&vt;"]
                ),
                ExpectedDefinition(
                    glosses: [
                        "to come",
                        "to go"
                    ],
                    partsOfSpeech: ["&v5b;"]
                ),
                ExpectedDefinition(
                    glosses: [
                        "to go (well, etc.)",
                        "to proceed",
                        "to progress"
                    ],
                    partsOfSpeech: ["&v5b;", "&vi;"]
                )
            ]
        )

        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <misc> tags are correctly parsed.
    func testMisc() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1498010"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "負け犬"
                            ],
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "まけいぬ"
                            ],
                        }
                    ],
                    "sense": [
                        {
                            "misc": [
                                "&sl;",
                                "&derog;"
                            ],
                            "gloss": [
                                "unmarried and childless older woman"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1498010,
            terms: [
                ExpectedTerm(term: "負け犬"),
            ],
            readings: [
                ExpectedReading(
                    reading: "まけいぬ",
                    terms: ["負け犬"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["unmarried and childless older woman"],
                    miscellanea: [
                        "&sl;",
                        "&derog;"
                    ]
                )
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <field> tags are correctly parsed.
    func testField() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1479270"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "半減期"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "はんげんき"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "field": [
                                "&physics;",
                                "&chem;"
                            ],
                            "gloss": [
                                "half life"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1479270,
            terms: [
                ExpectedTerm(term: "半減期"),
            ],
            readings: [
                ExpectedReading(
                    reading: "はんげんき",
                    terms: ["半減期"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["half life"],
                    jargonUses: [
                        "&physics;",
                        "&chem;"
                    ]
                )
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <dial> tags are correctly parsed.
    func testDial() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "2067590"
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "めんこい"
                            ]
                        },
                        {
                            "reb": [
                                "めごい"
                            ]
                        },
                        {
                            "reb": [
                                "めんごい"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "dial": [
                                "&thb;",
                                "&hob;"
                            ],
                            "gloss": [
                                "dear",
                                "darling",
                                "adorable",
                                "precious",
                                "cute",
                                "lovely",
                                "sweet",
                                "beloved",
                                "charming"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 2067590,
            readings: [
                ExpectedReading(reading: "めんこい"),
                ExpectedReading(reading: "めごい"),
                ExpectedReading(reading: "めんごい"),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "dear",
                        "darling",
                        "adorable",
                        "precious",
                        "cute",
                        "lovely",
                        "sweet",
                        "beloved",
                        "charming"
                    ],
                    dialects: [
                        "&thb;",
                        "&hob;"
                    ]
                )
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <ant> tags are correctly parsed.
    func testAnt() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1355270"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "乗車"
                            ],
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "じょうしゃ"
                            ],
                        }
                    ],
                    "sense": [
                        {
                            "ant": [
                                "下車・げしゃ",
                                "降車・こうしゃ"
                            ],
                            "gloss": [
                                "boarding (a train, bus, etc.)",
                                "getting into (e.g. a taxi)"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1355270,
            terms: [
                ExpectedTerm(term: "乗車"),
            ],
            readings: [
                ExpectedReading(
                    reading: "じょうしゃ",
                    terms: ["乗車"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "boarding (a train, bus, etc.)",
                        "getting into (e.g. a taxi)"
                    ],
                    antonyms: [
                        "下車・げしゃ",
                        "降車・こうしゃ"
                    ]
                )
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    /// Test <xref> tags are correctly parsed.
    func testXref() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "1486730"
                    ],
                    "k_ele": [
                        {
                            "keb": [
                                "鼻が高い"
                            ]
                        },
                        {
                            "keb": [
                                "鼻がたかい"
                            ]
                        }
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "はながたかい"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "xref": [
                                "頭が高い",
                                "鼻の高い"
                            ],
                            "gloss": [
                                "proud"
                            ]
                        },
                        {
                            "gloss": [
                                "having a prominent nose"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 1486730,
            terms: [
                ExpectedTerm(term: "鼻が高い"),
                ExpectedTerm(term: "鼻がたかい"),
            ],
            readings: [
                ExpectedReading(
                    reading: "はながたかい",
                    terms: ["鼻が高い", "鼻がたかい"]
                ),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: ["proud"],
                    crossReferences: [
                        "頭が高い",
                        "鼻の高い",
                    ]
                ),
                ExpectedDefinition(
                    glosses: ["having a prominent nose"]
                ),
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
    
    func testLsource() {
        let testData = formatTestData(
            """
            [
                {
                    "ent_seq": [
                        "2070440"
                    ],
                    "r_ele": [
                        {
                            "reb": [
                                "コッペパン"
                            ]
                        }
                    ],
                    "sense": [
                        {
                            "lsource": [
                                {
                                    "_": "coupé",
                                    "$": {
                                        "xml:lang": "fre",
                                        "ls_type": "part",
                                        "ls_wasei": "y"
                                    }
                                },
                                {
                                    "_": "pão",
                                    "$": {
                                        "xml:lang": "por",
                                        "ls_type": "part",
                                        "ls_wasei": "y"
                                    }
                                }
                            ],
                            "gloss": [
                                "bread roll",
                                "hot dog bun"
                            ]
                        }
                    ]
                },
            ]
            """
        )
        
        let expected = ExpectedEntry(
            id: 2070440,
            readings: [
                ExpectedReading(reading: "コッペパン"),
            ],
            definitions: [
                ExpectedDefinition(
                    glosses: [
                        "bread roll",
                        "hot dog bun"
                    ],
                    languageSources: [
                        ExpectedLanguageSource(
                            isWasei: true,
                            language: "fre",
                            meaning: "coupé"
                        ),
                        ExpectedLanguageSource(
                            isWasei: true,
                            language: "por",
                            meaning: "pão"
                        )
                    ]
                ),
            ]
        )
        
        testParse(
            mockParser: mockParser,
            testData: testData,
            expected: expected
        )
    }
}
