// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AuctionMarketplace
 * @dev Smart contract para subastas en Sei Network
 */
contract AuctionMarketplace {
    struct Auction {
        uint256 auctionId;
        address seller;
        string itemId; // ID del producto en la app
        uint256 startTime;
        uint256 endTime;
        uint256 highestBid;
        address highestBidder;
        bool ended;
        bool cancelled;
    }

    struct Bid {
        address bidder;
        uint256 amount;
        uint256 timestamp;
    }

    // Estado del contrato
    uint256 private nextAuctionId;
    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => Bid[]) public auctionBids;
    mapping(uint256 => mapping(address => uint256)) public pendingReturns;

    // Eventos
    event AuctionCreated(
        uint256 indexed auctionId,
        address indexed seller,
        string itemId,
        uint256 endTime
    );

    event BidPlaced(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 amount
    );

    event AuctionEnded(
        uint256 indexed auctionId,
        address indexed winner,
        uint256 amount
    );

    event AuctionCancelled(uint256 indexed auctionId);

    event FundsWithdrawn(address indexed bidder, uint256 amount);

    // Modificadores
    modifier auctionExists(uint256 _auctionId) {
        require(_auctionId < nextAuctionId, "Auction does not exist");
        _;
    }

    modifier onlySeller(uint256 _auctionId) {
        require(
            auctions[_auctionId].seller == msg.sender,
            "Only seller can call this"
        );
        _;
    }

    modifier auctionNotEnded(uint256 _auctionId) {
        require(!auctions[_auctionId].ended, "Auction already ended");
        require(!auctions[_auctionId].cancelled, "Auction cancelled");
        _;
    }

    /**
     * @dev Crea una nueva subasta
     * @param _itemId ID del item a subastar
     * @param _duration Duración de la subasta en segundos
     */
    function createAuction(string memory _itemId, uint256 _duration)
        external
        returns (uint256)
    {
        require(_duration >= 3600, "Duration must be at least 1 hour"); // Mínimo 1 hora
        require(_duration <= 7 days, "Duration cannot exceed 7 days");

        uint256 auctionId = nextAuctionId++;
        uint256 endTime = block.timestamp + _duration;

        auctions[auctionId] = Auction({
            auctionId: auctionId,
            seller: msg.sender,
            itemId: _itemId,
            startTime: block.timestamp,
            endTime: endTime,
            highestBid: 0,
            highestBidder: address(0),
            ended: false,
            cancelled: false
        });

        emit AuctionCreated(auctionId, msg.sender, _itemId, endTime);
        return auctionId;
    }

    /**
     * @dev Realiza una oferta en una subasta
     * @param _auctionId ID de la subasta
     */
    function placeBid(uint256 _auctionId)
        external
        payable
        auctionExists(_auctionId)
        auctionNotEnded(_auctionId)
    {
        Auction storage auction = auctions[_auctionId];

        require(block.timestamp < auction.endTime, "Auction has ended");
        require(msg.sender != auction.seller, "Seller cannot bid");
        require(msg.value > 0, "Bid must be greater than 0");
        require(
            msg.value > auction.highestBid,
            "Bid must be higher than current highest bid"
        );

        // Si hay un postor anterior, permitir que retire sus fondos
        if (auction.highestBidder != address(0)) {
            pendingReturns[_auctionId][auction.highestBidder] += auction.highestBid;
        }

        // Actualizar la oferta más alta
        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;

        // Registrar la oferta
        auctionBids[_auctionId].push(
            Bid({
                bidder: msg.sender,
                amount: msg.value,
                timestamp: block.timestamp
            })
        );

        emit BidPlaced(_auctionId, msg.sender, msg.value);
    }

    /**
     * @dev Finaliza una subasta y transfiere fondos al vendedor
     * @param _auctionId ID de la subasta
     */
    function endAuction(uint256 _auctionId)
        external
        auctionExists(_auctionId)
        auctionNotEnded(_auctionId)
    {
        Auction storage auction = auctions[_auctionId];

        require(
            block.timestamp >= auction.endTime || msg.sender == auction.seller,
            "Auction not yet ended or caller not seller"
        );

        auction.ended = true;

        // Si hubo ofertas, transferir fondos al vendedor
        if (auction.highestBidder != address(0)) {
            payable(auction.seller).transfer(auction.highestBid);
        }

        emit AuctionEnded(_auctionId, auction.highestBidder, auction.highestBid);
    }

    /**
     * @dev Cancela una subasta (solo si no hay ofertas)
     * @param _auctionId ID de la subasta
     */
    function cancelAuction(uint256 _auctionId)
        external
        auctionExists(_auctionId)
        onlySeller(_auctionId)
        auctionNotEnded(_auctionId)
    {
        Auction storage auction = auctions[_auctionId];
        require(auction.highestBidder == address(0), "Cannot cancel auction with bids");

        auction.cancelled = true;
        emit AuctionCancelled(_auctionId);
    }

    /**
     * @dev Permite a los postores retirar sus fondos si fueron superados
     * @param _auctionId ID de la subasta
     */
    function withdraw(uint256 _auctionId) external auctionExists(_auctionId) {
        uint256 amount = pendingReturns[_auctionId][msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingReturns[_auctionId][msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit FundsWithdrawn(msg.sender, amount);
    }

    /**
     * @dev Obtiene información de una subasta
     * @param _auctionId ID de la subasta
     */
    function getAuction(uint256 _auctionId)
        external
        view
        auctionExists(_auctionId)
        returns (Auction memory)
    {
        return auctions[_auctionId];
    }

    /**
     * @dev Obtiene todas las ofertas de una subasta
     * @param _auctionId ID de la subasta
     */
    function getAuctionBids(uint256 _auctionId)
        external
        view
        auctionExists(_auctionId)
        returns (Bid[] memory)
    {
        return auctionBids[_auctionId];
    }

    /**
     * @dev Obtiene el número total de subastas
     */
    function getTotalAuctions() external view returns (uint256) {
        return nextAuctionId;
    }

    /**
     * @dev Verifica si una subasta está activa
     * @param _auctionId ID de la subasta
     */
    function isAuctionActive(uint256 _auctionId)
        external
        view
        auctionExists(_auctionId)
        returns (bool)
    {
        Auction memory auction = auctions[_auctionId];
        return
            !auction.ended &&
            !auction.cancelled &&
            block.timestamp < auction.endTime;
    }

    /**
     * @dev Obtiene fondos pendientes de retiro para un postor
     * @param _auctionId ID de la subasta
     * @param _bidder Dirección del postor
     */
    function getPendingReturns(uint256 _auctionId, address _bidder)
        external
        view
        auctionExists(_auctionId)
        returns (uint256)
    {
        return pendingReturns[_auctionId][_bidder];
    }
}
