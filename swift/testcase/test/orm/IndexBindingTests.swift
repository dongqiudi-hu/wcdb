/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
import WCDBSwift

class IndexBindingTests: BaseTestCase {

    class BaselineTestObject: TableCodable {
        let variable: Int = 0   
        required init() {} 
        enum CodingKeys: String, CodingTableKey {
            typealias Root = BaselineTestObject
            case variable
            static let __objectRelationalMapping = TableBinding(CodingKeys.self)
            static var __indexBindings: [IndexBinding.Subfix:IndexBinding]? {
                return ["_index":IndexBinding(indexesBy: Properties.variable)]
            }
        }
    }
    
    class UniqueTestObject: TableCodable {
        let variable: Int = 0       
        required init() {}  
        enum CodingKeys: String, CodingTableKey {
            typealias Root = UniqueTestObject
            case variable
            static let __objectRelationalMapping = TableBinding(CodingKeys.self)
            static var __indexBindings: [IndexBinding.Subfix:IndexBinding]? {
                return ["_index":IndexBinding(isUnique: true, indexesBy: Properties.variable)]
            }
        }
    }

    class MultiIndexesTestObject: TableCodable {
        let variable1: Int = 0 
        let variable2: Int = 0  
        required init() {}
        enum CodingKeys: String, CodingTableKey {
            typealias Root = MultiIndexesTestObject
            case variable1
            case variable2
            static let __objectRelationalMapping = TableBinding(CodingKeys.self)
            static var __indexBindings: [IndexBinding.Subfix:IndexBinding]? {
                return ["_index":IndexBinding(indexesBy: Properties.variable1, Properties.variable2)]
            }
        }
    }

    func testIndexBinding() {
        ORMIndexBindingAssertEqual(BaselineTestObject.self, "CREATE INDEX IF NOT EXISTS BaselineTestObject_index ON BaselineTestObject(variable)")
        
        ORMIndexBindingAssertEqual(UniqueTestObject.self, "CREATE UNIQUE INDEX IF NOT EXISTS UniqueTestObject_index ON UniqueTestObject(variable)")
        
        ORMIndexBindingAssertEqual(MultiIndexesTestObject.self, "CREATE INDEX IF NOT EXISTS MultiIndexesTestObject_index ON MultiIndexesTestObject(variable1, variable2)")
    }
}
