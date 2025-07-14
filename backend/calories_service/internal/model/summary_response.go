package model

// SummaryResponse — сводка по дню
type SummaryResponse struct {
    Consumed  int `json:"consumed"`
    Burned    int `json:"burned"`
    Remaining int `json:"remaining"`
    Goal      int `json:"goal"`
}
