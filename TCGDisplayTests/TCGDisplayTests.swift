//
//  TCGDisplayTests.swift
//  TCGDisplayTests
//
//  Created by Filipe de Almeida António on 28/01/2026.
//

import XCTest
@testable import TCGDisplay

@MainActor
final class CardListViewModelTests: XCTestCase {

    var viewModel: CardListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CardListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFilterCards_prefixMatch() {
        viewModel.allCards = [
            PokemonCard(id: "1", name: "Pikachu", image: "https://img.com/pikachu.png", hp: 50, types: ["Lightning"]),
            PokemonCard(id: "2", name: "Charmander", image: "https://img.com/charmander.png", hp: 60, types: ["Fire"]),
            PokemonCard(id: "3", name: "Bulbasaur", image: nil, hp: 40, types: ["Grass"]) // filtered out
        ]

        viewModel.searchText = "Pi"
        viewModel.filterCards()

        XCTAssertEqual(viewModel.cards.count, 1)
        XCTAssertEqual(viewModel.cards.first?.name, "Pikachu")
    }

    func testFilterCards_fuzzyMatch() {
        viewModel.allCards = [
            PokemonCard(id: "1", name: "Pikachu", image: "https://img.com/pikachu.png", hp: 50, types: ["Lightning"]),
            PokemonCard(id: "2", name: "Charmander", image: "https://img.com/charmander.png", hp: 60, types: ["Fire"])
        ]

        viewModel.searchText = "man"
        viewModel.filterCards()

        XCTAssertEqual(viewModel.cards.count, 1)
        XCTAssertEqual(viewModel.cards.first?.name, "Charmander")
    }

    func testFilterCards_filtersOutCardsWithoutImage() {
        viewModel.allCards = [
            PokemonCard(id: "1", name: "Pikachu", image: "https://img.com/pikachu.png", hp: 50, types: ["Lightning"]),
            PokemonCard(id: "2", name: "Charmander", image: nil, hp: 60, types: ["Fire"])
        ]

        viewModel.searchText = ""
        viewModel.filterCards()

        XCTAssertEqual(viewModel.cards.count, 1)
        XCTAssertEqual(viewModel.cards.first?.name, "Pikachu")
    }
}


@MainActor
final class CardDetailViewModelTests: XCTestCase {

    var viewModel: CardDetailViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CardDetailViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testCardPricingAvailable() async {
        let pricing = CardMarketPricing(
            updated: "2026-01-29",
            unit: "USD",
            idProduct: 123,
            avg: 10.5,
            low: 8.0,
            trend: 1.2,
            avg1: nil,
            avg7: nil,
            avg30: nil,
            avgHolo: 15.0,
            lowHolo: 12.0,
            trendHolo: 0.8
        )

        let card = PokemonCardDetail(
            category: "pokemon",
            id: "1",
            illustrator: nil,
            image: "https://img.com/pikachu.png",
            localId: nil,
            name: "Pikachu",
            rarity: "Common",
            set: nil,
            variants: nil,
            variantsDetailed: nil,
            dexId: nil,
            hp: 50,
            types: ["Lightning"],
            evolveFrom: nil,
            description: nil,
            stage: nil,
            attacks: nil,
            weaknesses: nil,
            retreat: nil,
            regulationMark: nil,
            legal: nil,
            updated: nil,
            pricing: CardPricing(cardmarket: pricing, tcgplayer: nil)
        )

        viewModel.card = card
        XCTAssertNotNil(viewModel.card?.pricing?.cardmarket)
        XCTAssertEqual(viewModel.card?.pricing?.cardmarket?.avg, 10.5)
        XCTAssertEqual(viewModel.card?.pricing?.cardmarket?.lowHolo, 12.0)
    }
}

