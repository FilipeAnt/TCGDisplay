//
//  TCGDisplayTests.swift
//  TCGDisplayTests
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import XCTest
@testable import TCGDisplay

// MARK: - CardListViewModel Tests
@MainActor
final class CardListViewModelTests: XCTestCase {

    func testFilterCards_prefixMatch() async {
        let vm = CardListViewModel()
        
        vm.allCards = [
            PokemonCard(id: "1", name: "Pikachu", image: "https://example.com/pikachu.png", hp: 50, types: ["Lightning"]),
            PokemonCard(id: "2", name: "Charmander", image: "https://example.com/charmander.png", hp: 60, types: ["Fire"]),
            PokemonCard(id: "3", name: "Bulbasaur", image: nil, hp: 40, types: ["Grass"])
        ]
        
        vm.searchText = "Pi"
        vm.filterCards()
        
        XCTAssertEqual(vm.cards.count, 1)
        XCTAssertEqual(vm.cards.first?.name, "Pikachu")
    }

    func testFilterCards_filtersOutCardsWithoutImage() async {
        let vm = CardListViewModel()
        
        vm.allCards = [
            PokemonCard(id: "1", name: "Pikachu", image: "https://example.com/pikachu.png", hp: 50, types: ["Lightning"]),
            PokemonCard(id: "2", name: "Charmander", image: nil, hp: 60, types: ["Fire"])
        ]
        
        vm.searchText = ""
        vm.filterCards()
        
        XCTAssertEqual(vm.cards.count, 1)
        XCTAssertEqual(vm.cards.first?.name, "Pikachu")
    }
}
